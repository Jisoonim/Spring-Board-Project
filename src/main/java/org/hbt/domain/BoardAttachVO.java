package org.hbt.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
	
	private String uuid;
	
	private String uploadPath;
	
	private String fileName;
	
	private boolean filetype;
	
	private Long bno;

}
