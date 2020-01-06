package org.hbt.service;

import java.util.List;

import org.hbt.domain.BoardAttachVO;
import org.hbt.domain.BoardVO;
import org.hbt.dto.PageDTO;

public interface BoardService {
	
	public void register(BoardVO vo); //등록
	
	public BoardVO get(Long bno); //조회
	
	public boolean modify(BoardVO board); //수정
	
	public boolean remove(Long bno); //삭제
	
	public List<BoardVO> getList(PageDTO dto); //리스트출력
	
	public int getListCount(PageDTO dto); //게시물 총 갯수
	
	public List<BoardAttachVO> getAttachList(Long bno);


}
