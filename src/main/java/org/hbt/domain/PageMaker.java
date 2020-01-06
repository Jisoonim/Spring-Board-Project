package org.hbt.domain;

import org.hbt.dto.PageDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PageMaker { // 화면에 뿌려주는 pageMaker

	private int start, end; // 페이지 맨처음 / 맨끝

	private boolean prev, next; // 이전페이지로 / 다음페이지로

	private int total; // 총 게시글 수(total)

	private PageDTO dto;

	public PageMaker(PageDTO dto, int total) {

		this.dto = dto;
		this.total = total;
		
		this.end = (int) (Math.ceil(dto.getPage() / 10.0)) * 10;
		
		this.start = this.end - 9;
		
		int realEnd = (int) (Math.ceil(total * 1.0) / dto.getAmount());
		
		if(realEnd < this.end) {
			this.end = realEnd;
		}
		
		this.prev = this.start > 1;
		
		this.next = this.end < realEnd;

//		int tempEnd = (int) (Math.ceil(dto.getPage() / 10)) * 10;
//
//		this.start = tempEnd - 9;
//
//		this.prev = this.start > 1;
//
//		int realEnd = (int) (Math.ceil((total * 1.0) / dto.getAmount()));
//
//		if (realEnd < tempEnd) {
//			this.end = realEnd;
//		} else {
//			this.end = tempEnd;
//		}
//
//		this.next = this.end < realEnd;
	}

}
