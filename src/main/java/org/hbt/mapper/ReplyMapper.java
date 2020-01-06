package org.hbt.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.hbt.domain.ReplyVO;
import org.hbt.dto.PageDTO;

public interface ReplyMapper {
	
	public int insert(ReplyVO vo);
	
	public ReplyVO read(Long bno);
	
	public int delete(Long rno);
	
	public int update(ReplyVO reply);
	
	public List<ReplyVO> getListWithPaging( //댓글 페이징
			@Param("dto") PageDTO dto,
			@Param("bno") Long bno); 
	
	public int getCountByBno(Long bno);

}
