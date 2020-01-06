package org.hbt.service;

import java.util.List;

import org.hbt.domain.ReplyPageDTO;
import org.hbt.domain.ReplyVO;
import org.hbt.dto.PageDTO;
import org.hbt.mapper.BoardMapper;
import org.hbt.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;

	@Override
	@Transactional
	public int register(ReplyVO vo) { //댓글 등록 

		log.info("Register......." + vo);
		
		boardMapper.updateReplyCnt(vo.getBno(), 1); //댓글을 작성완료시 +1추가

		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) { //댓글 조회

		log.info("get......." + rno);

		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) { //댓글 수정

		log.info("modify......." + vo);

		return mapper.update(vo);
	}

	@Override
	@Transactional
	public int remove(Long rno) { //댓글 삭제

		log.info("remove......." + rno);
		
		ReplyVO vo = mapper.read(rno);
		
		boardMapper.updateReplyCnt(vo.getBno(), -1); //댓글 삭제시 -1

		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(PageDTO dto, Long bno) { //댓글 목록

		log.info("get Reply List of a Board " + bno);

		return mapper.getListWithPaging(dto, bno);
	}

	@Override
	public ReplyPageDTO getListPage(PageDTO dto, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(dto, bno));
	}

}
