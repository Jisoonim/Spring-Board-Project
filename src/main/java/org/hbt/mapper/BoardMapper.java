package org.hbt.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.hbt.domain.BoardVO;
import org.hbt.dto.PageDTO;

public interface BoardMapper {
	
	public int insert(BoardVO board); //등록
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO selectOne(Long bno); //조회
	
	public int delete(Long bno); //삭제
	
	public int update(BoardVO board); //수정
	
	public List<BoardVO> listPage(PageDTO dto); //페이징
	
	public int countPage(PageDTO dto); //총 게시물 갯수
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	
	


}
