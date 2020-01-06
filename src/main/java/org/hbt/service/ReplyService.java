package org.hbt.service;

import java.util.List;

import org.hbt.domain.ReplyPageDTO;
import org.hbt.domain.ReplyVO;
import org.hbt.dto.PageDTO;

public interface ReplyService {

	public int register(ReplyVO vo);
	
	public ReplyVO get(Long rno);
	
	public int modify(ReplyVO vo);
	
	public int remove(Long rno);
	
	public List<ReplyVO> getList(PageDTO dto, Long bno);
	
	public ReplyPageDTO getListPage(PageDTO dto, Long bno);
}
