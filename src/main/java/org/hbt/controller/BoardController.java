package org.hbt.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.hbt.domain.BoardAttachVO;
import org.hbt.domain.BoardVO;
import org.hbt.domain.PageMaker;
import org.hbt.dto.PageDTO;
import org.hbt.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	@Setter(onMethod_ = @Autowired)
	private BoardService service;

	@GetMapping({ "/get", "/modify" }) // get = 페이지 조회
	public void get(@RequestParam("bno") Long bno, Model model) { // bno값을 좀 더 명시적으로 처리
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));

	}

	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("dto") PageDTO dto, RedirectAttributes rttr) {
		log.info("수정완료 : " + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("page", dto.getPage());
		rttr.addAttribute("amount", dto.getAmount());

		return "redirect:/board/list" + dto.getListLink();// p.216
	}

	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("dto") PageDTO dto, RedirectAttributes rttr,
			String writer) {

		log.info(bno + "번글 삭제 완료............");

		List<BoardAttachVO> attachList = service.getAttachList(bno);

		if (service.remove(bno)) {

			// delete Attach Files
			deleteFiles(attachList);

			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("page", dto.getPage());
		rttr.addAttribute("amount", dto.getAmount());

		return "redirect:/board/list" + dto.getListLink();
	}

	@GetMapping("/register") // register = 게시물 등록페이지
	@PreAuthorize("isAuthenticated()")
	public void registerGET() {
		log.info("get register......");
		
	}

	@PostMapping("/register")
//	@PreAuthorize("isAuthenticated()")
	public String registerPost(BoardVO board, RedirectAttributes rttr) {
		log.info("post register......");

		log.info("register: " + board);

		if (board.getAttachList() != null) {

			board.getAttachList().forEach(attach -> log.info(attach));
		}

		log.info("++++++++++++++++++++++++++++++++++++++++++++++");

		// boolean result =
	              	service.register(board);

		// log.info("게시판 등록 성공 / 실패 : " + result);

		rttr.addFlashAttribute("result", board.getBno());

		log.info("++++++++++++++++++++++++++++++++++++++++++++++");

		return "redirect:/board/list"; // 등록성공시 list페이지로 이동.

	}

	@GetMapping("/list")
	public void list(PageDTO dto, Model model) {// model : controller에 생성된 데이터를 담아서 view에 전달해주는 객체.
		log.info("get List..........." + dto);

		model.addAttribute("list", service.getList(dto));
		int total = service.getListCount(dto);

		PageMaker pg = new PageMaker(dto, total);
		model.addAttribute("pageMaker", pg);

		log.info("+++++++++++++ 총 게시물 갯수는  " + service.getListCount(dto) + " 개 입니다. +++++++++++++");

	}

	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {

		log.info("getAttachList : " + bno);

		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}

	private void deleteFiles(List<BoardAttachVO> attachList) { // 첨부파일 삭제

		if (attachList == null || attachList.size() == 0) {
			return;
		}

		log.info("delete attach files...............");
		log.info(attachList);

		attachList.forEach(attach -> {

			try {

				Path file = Paths.get("C:\\zzz\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_"
						+ attach.getFileName());

				Files.deleteIfExists(file);

				if (Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\zzz\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid()
							+ "_" + attach.getFileName());

					Files.delete(thumbNail);
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			} // end catch
		});// end foreach
	}

//	@GetMapping("/list")
//	public void list(
//			@RequestParam(defaultValue = "1") int page,
//			@RequestParam(defaultValue = "10") int amount,
//			String keyword,
//			String[] types,
//			Model model) {
//		
//		log.info("............"+ page);
//		log.info("............"+ amount);
//		log.info("............"+ keyword);
//		log.info("............"+ Arrays.toString(types));
//	}

}
