package org.hbt.dto;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class PageDTO {

	private int page;

	private int amount; // 하단에 10페이지씩 보여지게 한다.

	private String type;

	private String keyword;

	public PageDTO() {
		this(1, 10);
	}

	public PageDTO(int page, int amount) {
		this.page = page;
		this.amount = amount;
	}

	public int getSkip() {

		return (page - 1) * amount; // 기본 페이지가 1이면, 0 * 10 즉,최근글 10개를 출력한다. / 페이지가 2이면 최근 글 1개를 제외한 10개를 출력한다.

	}

	public String[] getTypes() {
		if(type == null || type.trim().length() == 0) {
			return null;
		}
		return type.split("");
	}

	public String getListLink() {
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("page", this.page)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
				
				return builder.toUriString();
	}
	
}