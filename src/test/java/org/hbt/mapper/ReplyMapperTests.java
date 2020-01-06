package org.hbt.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.hbt.domain.ReplyVO;
import org.hbt.dto.PageDTO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	private Long[] bnoArr = {142L, 140L, 134L, 133L, 132L};
	
	@Setter(onMethod_ = @Autowired )
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		log.info(mapper);
	}
	
	@Test
	public void testCreate() { //댓글 생성
		IntStream.rangeClosed(132, 740).forEach(i -> {
			ReplyVO vo = new ReplyVO();
			
			vo.setBno(bnoArr[i % 5]);
			vo.setReply("파밍" + i);
			vo.setReplyer("우히히" + i);
			
			mapper.insert(vo);
		});
	}
	
	@Test
	public void testRead() { //댓글 조회
		Long targetRno = 8L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		log.info(vo);
	}
	
	@Test
	public void testDelete() { //댓글 삭제
		Long targetRno = 9L;
		
		mapper.delete(targetRno);
	}
	
	@Test
	public void testUpdate() { //댓글 수정
		Long targetRno = 12L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		vo.setReply("댓글수정할게요");
		
		int count = mapper.update(vo);
		
		log.info("Update Count : " + count);
	}

	@Test
	public void testList() { //댓글 리스트
		PageDTO dto = new PageDTO();
		
		List<ReplyVO> replies = mapper.getListWithPaging(dto, bnoArr[0]);
		
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testList2() { //댓글 페이징처리 테스트
		
		PageDTO dto = new PageDTO(2,10);
		
		List<ReplyVO> replies = mapper.getListWithPaging(dto, 142L);
		
		replies.forEach(reply -> log.info(reply));
	}
}
