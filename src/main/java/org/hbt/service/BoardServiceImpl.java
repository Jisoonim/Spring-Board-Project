package org.hbt.service;

import java.util.List;

import org.hbt.domain.BoardAttachVO;
import org.hbt.domain.BoardVO;
import org.hbt.dto.PageDTO;
import org.hbt.mapper.BoardAttachMapper;
import org.hbt.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;

	@Override
	@Transactional
	public void register(BoardVO board) {

		log.info("service register.........." + board);

		mapper.insertSelectKey(board); // insert? insertSelectKey?

		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {

			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public List<BoardVO> getList(PageDTO dto) {
		log.info("get List.................");
		log.info(mapper.getClass().getName());
		return mapper.listPage(dto);
	}

	@Override
	public int getListCount(PageDTO dto) {
		return mapper.countPage(dto);
	}

	@Override
	@Transactional
	public boolean modify(BoardVO board) {
		log.info("modify............." + board);

		attachMapper.deleteAll(board.getBno());

		boolean modifyResult = mapper.update(board) == 1;

		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {

				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get.........." + bno);
		return mapper.selectOne(bno);
	}
	
	@Override
	@Transactional
	public boolean remove(Long bno) {
		log.info("remove............" + bno);

		attachMapper.deleteAll(bno);

		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {

		log.info("get Attach list by bno" + bno);

		return attachMapper.findByBno(bno);
	}

}
