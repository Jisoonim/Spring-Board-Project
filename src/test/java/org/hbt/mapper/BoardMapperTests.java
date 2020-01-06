package org.hbt.mapper;

import org.aspectj.lang.annotation.Before;
import org.hbt.domain.BoardVO;
import org.hbt.dto.PageDTO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
		"file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
@WebAppConfiguration

public class BoardMapperTests {
	
	@Autowired
	private BoardMapper mapper;
	
	@Setter(onMethod_ = {@Autowired})
	private WebApplicationContext ctx;
	
	 private MockMvc mockMvc;
	 
	 @Test
	 public void testSearch() {
		 
		 PageDTO dto = new PageDTO();
		 dto.setKeyword("집갈래");
		 dto.setType("C");

		 mapper.listPage(dto).forEach(vo -> {
			 log.info(vo);
		 });
		 
		 log.info(mapper.countPage(dto));
		 
//		 List<BoardVO> list = mapper.listPage(dto);
//		 
//		 list.forEach(board -> log.info(board));
//		 
	 }
	 
	 @Test
	 public void testList() throws Exception {
		 
		 log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
				 .andReturn()
				 .getModelAndView()
				 .getModelMap());
	 }
	 @Before(value = "")
	 @Test
	 public void setup() {
		 this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	 }
	
	@Test
	public void testModify() throws Exception {
		
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
				.param("bno", "132")
				.param("title", "수정되었습니다")
				.param("content", "수정된내용이다")
				.param("writer", "modify00"))
				.andReturn().getModelAndView().getViewName();
		
		log.info(resultPage);
				
	}
	
	
	@Test
	public void testUpdateOne() { //수정

		BoardVO board = new BoardVO();
		board.setBno(134L);
		board.setTitle("제목수정테스트");
		board.setContent("내용수정테스트");
		board.setWriter("작성자수정테스트");
		
		int count = mapper.update(board);
		
		log.info("수정(1이 나오면 true) : " + count);
		
	}
	
	@Test
	public void testDeleteOne() {//삭제(delete id값도 같아야한다 / binding에러)
		log.info("삭제(1이 나오면 true) : " + mapper.delete(135L));

	}
	
	
	@Test
	public void testSeleteOne() { //조회
		BoardVO bno = mapper.selectOne(135L);
		
		log.info(bno);
	}
	
	
	@Test
	public void testListPage() {
		
		PageDTO dto = new PageDTO();
		dto.setPage(10);
		
		mapper.listPage(dto).forEach(vo -> {
			log.info(vo); //게시글 출력
		});
		
		log.info("+++++++++++++ 총 게시물 갯수는  " + mapper.countPage(dto) + "개 입니다  +++++++++++++ ");
	}
	
	@Test
	public void testInsert() { //등록
		
		for(int i = 1; i < 2; i++) {
		BoardVO vo = new BoardVO();
		vo.setTitle("제목." + i);
		vo.setWriter("지수." + i);
		vo.setContent("내용." + i);
		
		log.info("+++++++++++++++++++++++++++++");
		log.info(mapper.insert(vo));
	}
	}
}
