<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta charset="UTF-8">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>

<div class="bigPictureWrapper">
<div class="bigPicture">
</div>
</div>

<style>

.uploadResult {
width : 100%;
background-color: pink;
}

.uploadResult ul {
display: flex;
flex-flow: row;
justify-content: center;
align-items: center;
}

.uploadResult ul li {
list-style: none;
padding: 10px;
align-content: center;
text-align: center;
}

.uploadResult ul li img{
width: 100px;
}

.uploadResult ul li span {
color: white;
}

.bigPictureWrapper {
position: absolute;
display: none;
justify-content: center;
align-items: center;
top: 0%;
width: 100%;
height: 100%;
background-color: gray;
z-index: 100;
background:rgba(255,255,255,0.5);
}

.bigPicture {
position: relative;
display: flex;
justify-content: center;
align-items: center;
}

.bigPicture img {
width: 600px;
}

</style>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800">Board Read</h1>

	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h6 class="m-0 font-weight-bold text-primary">게시글 내용</h6>
		</div>
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable" width="100%"
					cellspacing="0">
					<div class="form-group">
						<label>번호</label> <input class="form-control" name='bno'
							value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>제목</label> <input class="form-control" name='title'
							value='<c:out value="${board.title}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" name='content' rows="3"
							readonly="readonly"><c:out value="${board.content}" /></textarea>
					</div>

					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer"
							value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>

					<sec:authentication property="principal" var="pinfo"/>
					<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
					
					<button data-oper='modify' class="btn btn-danger"
						onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">수정</button>
						
					</c:if>
					</sec:authorize>
					
					<button data-oper='list' class="btn btn-info"
						onclick="location.href='/board/list'">목록으로</button>

					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value='<c:out value = "${board.bno}"/>'>
						<input type="hidden" name="page" value='<c:out value = "${dto.page}"/>'>
						<input type="hidden" name="amount" value='<c:out value = "${dto.amount}"/>'>
						<input type="hidden" name="keyword" value='<c:out value = "${dto.keyword}"/>'>
						<input type="hidden" name="type" value='<c:out value = "${dto.type}"/>'>
					</form>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- 파일첨부 -->
<div class="container-fluid">
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h6 class="m-0 font-weight-bold text-primary">Files</h6>
		</div>

		<div class="card-body">
				
			<div class="uploadResult">
				<ul>

				</ul>
			</div>
		</div>
	</div>
</div>
	
<!-- Begin Page Content -->
<div class="container-fluid">
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h4 class="m-0 font-weight-bold text-primary">Reply
			<sec:authorize access="isAuthenticated()">
			
			<button id='addReplyBtn' class="btn btn-primary btn-xs float-right">댓글 추가</button></h4>
			</sec:authorize>
		</div>
		<div class="card-body">
			<ul class="chat">
				<li class="left clearfix" data-rno='' value='<c:out value="${vo.rno}"/>'>
					<div>
						<div class="header">
							<strong class="primary-font" value='<c:out value="${vo.replyer}"/>'></strong> 
							<small class="float-right text-muted" value='<c:out value="${vo.replyDate}"/>'></small>
						</div>
						<p value='<c:out value="${vo.reply}"/>'></p>
					</div>
				</li>
			</ul>
		</div>
		<div class="panel-footer">
		
		</div>
	</div>
</div>
 <!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
	      </div>
	      <div class="modal-body">
	      
	      <div class="form-group">
	      <label>Reply</label>
	      <input class="form-control" name="reply" value="New Reply!!!">
	      </div>
	      
	      <div class="form-group">
	      <label>Replyer</label>
	      <input class="form-control" name="replyer" value="replyer" readonly="readonly">
	      </div>
	      
	      <div class="form-group">
	      <label>Reply Date</label>
	      <input class="form-control" name="replyDate" value="">
	      </div>
	      
	      </div>
      <div class="modal-footer">
<sec:authentication property="principal" var="pinfo"/>
<sec:authorize access="isAuthenticated()">

<c:if test="${pinfo.username eq board.writer}">

        <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
</c:if>
</sec:authorize>
        <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
        <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
        <button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal end -->
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
$(document).ready(function() {
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	     showList(1);
	
	function showList(page) {
		
		console.log("show List Page: " + page);
		
		replyService.getList({bno : bnoValue, page : page || 1}, function(replyCnt, list) {
			
			console.log("replyCnt: " + replyCnt);
			//console.log("list: " + list);
			console.log(list);
			
			if(page == -1) {
				pageNum = Math.ceil(replyCnt / 10.0);
				showList(pageNum);
				return;
			}
			
			var str = "";
			
			if(list == null || list.length == 0) {
				return;
			}
			for(var i = 0, len = list.length || 0; i < len; i++) {
				str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str += "<div><div class='header'><strong class='primary-font'>["+ list[i].rno +"] "+list[i].replyer+"</strong>";
				str += "<small class='float-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
				str += "<p>"+list[i].reply+"</p></div></li>";
			}//end for
			replyUL.html(str);
			
			showReplyPage(replyCnt);
		});//end function
	}//end showList
	
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	var modalCloseBtn = $("modalCloseBtn");
	
	var replyer = null;
	
	
	<sec:authorize access="isAuthenticated()">
	
	replyer = '<sec:authentication property="principal.username" />';
	
	</sec:authorize>
	
	 var csrfHeaderName = "${_csrf.headerName}";
	  var csrfTokenValue = "${_csrf.token}";
	
	$("#addReplyBtn").on("click", function(e) {
		
		modal.find("input").val("");
		modal.find("input[name='replyer']").val(replyer);
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
		
		showList(pageNum); //13페이지에서 댓글을작성했다면 댓글작성하고도 13페이지 출력가능하게해야함.
	}); //end addReplyBtn
	
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	modalRegisterBtn.on("click", function(e) { //댓글 등록 기능
		
		var reply = {
				reply : modalInputReply.val(),
				 replyer : modalInputReplyer.val(),
				 bno : bnoValue
		};
		replyService.add(reply, function(result) {
			alert(result);
			
			modal.find("input").val("");
			modal.modal("hide");
			
			showList(1); //-1? 1? page?
		});
	}); //end modalRegisterBtn 
	
	//댓글 조회 클릭 이벤트->수정/삭제 가능
	$(".chat").on("click", "li", function(e) {
		
		var rno = $(this).data("rno");

		replyService.get(rno, function(reply) {
			
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
			modal.data("rno", reply.rno);
			
			modal.find("button[id !='modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			$(".modal").modal("show");
		});
		
	});// end chat
	
	modalModBtn.on("click", function(e) { //댓글 수정 기능
		
		var originalReplyer = modalInputReplyer.val();
		
		var reply = {
				rno : modal.data("rno"),
				reply : modalInputReply.val(),
				replyer : originalReplyer
				};
		
		if(!replyer) {
			alert("로그인 후 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		console.log("Original Replyer : " + originalReplyer);
		
		if(replyer != originalReplyer) {
			alert("자신이 작성한 댓글만 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		replyService.update(reply, function(result) {
			alert(result);
			modal.modal("hide");
			showList(pageNum);
		});
	}); //modal modify
	
	modalRemoveBtn.on("click", function(e) { //댓글 삭제 기능
		
		var rno = modal.data("rno");
	
		console.log("RNO : " + rno);
		console.log("REPLYER : " + replyer);
		
		if(!replyer) {
			alert("로그인 후 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();
		
		console.log("Original Replyer : " + originalReplyer); //댓글의 원래 작성자
		
		if(replyer != originalReplyer) {
			
			alert("자신이 작성한 댓글만 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, originalReplyer, function(result) {
			
			alert(result);
			modal.modal("hide");
			showList(pageNum);
			
		});
		
	});// modal Remove
	
	//panel-footer
	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	
	function showReplyPage(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		
		var prev = startNum != 1;
		var next = false;
		
		if(endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt / 10.0);
		}
		
		if(endNum * 10 < replyCnt) {
			next = true;
		}
		
		var str = "<ul class='pagination float-right'>";
		
		if(prev) {
			str += "<li class='page-item'><a class='page-link' href='"+(startNum - 1)+"'>Previous</a></li>";
		}
			
		for(var i = startNum; i <= endNum; i++) {
			var active = (pageNum == i ? "active" : "");
			
			str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		}
		
		if(next) {
			str += "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
		}
		
		str += "</ul></div>";
		
		console.log(str);
		
		replyPageFooter.html(str);
	} //end panel-footer
	
	//페이지의 번호를 클릭시 새로운 댓글을 가져오기
	replyPageFooter.on("click", "li a", function(e) {
		e.preventDefault();
		console.log("page click");
		
		var targetPageNum = $(this).attr("href");
		
		console.log("targetPageNum: " + targetPageNum);
		
		pageNum = targetPageNum;
		
		showList(pageNum);
		
	});//end replyPageFooter
	
var bno = '<c:out value="${board.bno}"/>';
	
	$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
		
		console.log(arr);
		
		var str = "";
		
		$(arr).each(function(i, attach) {
			
			//이미지 타입
			if(attach.filetype) {
				var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
				
				str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str += "</li>";
			}else {
				
				str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
				str += "<span> "+attach.fileName+"</span><br/>";
				str += "<img src='/resources/img/attach1.png'>";
				str += "</div>";
				str += "</li>";
			}
		}); 
		
		$(".uploadResult ul").html(str);
		
	});//end getJSON
	
	$(".uploadResult").on("click", "li", function(e) {
		
		console.log("view image");
		
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		
		if(liObj.data("type")) {
			showImage(path.replace(new RegExp(/\\/g),"/"));
		}else {
			//download
			self.location ="/download?fileName=" + path;
		}
	});
	
	function showImage(fileCallPath) {
		
		//alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture")
  		.html("<img src='/display?fileName="+fileCallPath+"'>")
  		.animate({width :'100%', height :'100%'}, 1000);
	}
	
	$(".bigPictureWrapper").on("click", function(e) { //이미지확대했다가 1초뒤에 꺼지게하기
		 $(".bigPicture").animate({width :'0%', height :'0%'}, 1000);
		 setTimeout(function() {
			 $(".bigPictureWrapper").hide();
		 }, 1000);
	  });
	
});//end ready

 </script>
 
<!--  <script>
$(document).ready(function() {
	(function() {
	
	var bno = '<c:out value="${board.bno}"/>';
	
	$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
		
		console.log(arr);
		
		var str = "";
		
		$(arr).each(function(i, attach) {
			//이미지 타입
			if(attach.filetype) {
				var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
				
				str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str += "</li>";
			}else {
				
				str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
				str += "<span> "+attach.fileName+"</span><br/>";
				str += "<img src='/resources/img/attach.jpg'>";
				str += "</div>";
				str += "</li>";
			}
		}); 
		
		$("uploadResult ul").html(str);
		
	});//end getJSON
	
})();//end function
});
 
</script> -->

<!--  <script type="text/javascript">
	$(document).ready(function() {
		console.log(replyService);

		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click", function(e) {

			operForm.attr("action", "/board/modify").submit();

		});
	}); 
</script> -->
<%@include file="../includes/footer.jsp"%>