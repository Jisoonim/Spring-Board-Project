package org.hbt.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {

	private Long rno;
	
	private Long bno;
	
	private String reply;
	
	private String replyer;
	
	private Date replyDate;
	
	private Date updateDate;
	
//	1.섬네일이 보여지지않는 현상
//
//	2.ppt파일 업로드안됨
//
//	3.Delete success알람이 2번뜨는현상발생
//
//	4.게시물없는번호에 댓글을 삽입하면 오류가뜨지만 rno번호는 하나생성되는현상
//
//	5.댓글수정시 replyer는 수정안되는현상(안되는게 맞을수도있는데 콘솔에는 바꼈다뜸)
	
// 6.modal창 글작성시는 모달이 안뜨고 수정할때만 뜨는현상

	
}
