<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- Date format -->
<%@include file="../includes/header.jsp" %>
<!DOCTYPE html>
<html>
        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">List</h1>
          <p class="mb-4">게시물을 작성해보세요.</p>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h5 class="m-0 font-weight-bold text-primary">Board List <button id='regBtn' type="button" class="btn btn-primary float-right"><h6>Register New Board</h6></button></h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr align="center">
                      <th>번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>작성일</th>
                      <th>수정일</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${list}" var="board">
                     <tr align="center">
                      <td><c:out value="${board.bno}" /></td>
					<td><a class="move" href='/board/get?bno=<c:out value="${board.bno}"/>'>
                      		<c:out value="${board.title}" /><b>[ <c:out value="${board.replyCnt}" /> ]</b></a></td>
                      <td><c:out value="${board.writer}" /></td>
                      <td><fmt:formatDate value="${board.regdate}" pattern = "yyyy-MM-dd" /></td>
                       <td><fmt:formatDate value="${board.updatedate}" pattern = "yyyy-MM-dd" /></td>
                    </tr>
                    </c:forEach>
                  </tbody>
                </table>
                <!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title" id="myModalLabel">Modal Title</h4>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	      </div>
		      <div class="modal-body">처리가 완료되었습니다.</div>
	      <div class="modal-body">
	      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!-- Modal end -->
              </div>
            </div>
          </div>
         
     <!-- 검색기능  -->    
	<form id="f1"  action="/board/list" method="get">
		<select id="stype">
		<option value=""  <c:out value="${pageMaker.dto.type == null ? 'selected' : ''}"/>>--</option>
		<option value="T" <c:out value="${pageMaker.dto.type eq 'T' ? 'selected' : ''}"/>>제목</option>
		<option value="C" <c:out value="${pageMaker.dto.type eq 'C' ? 'selected' : ''}"/>>내용</option>
		<option value="W" <c:out value="${pageMaker.dto.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
		<option value="TC"<c:out value="${pageMaker.dto.type eq 'TC' ? 'selected' : ''}"/>>제목+내용</option>
		<option value="CW"<c:out value="${pageMaker.dto.type eq 'CW' ? 'selected' : ''}"/>>내용+작성자</option>
		<option value="TCW"<c:out value="${pageMaker.dto.type eq 'TCW' ? 'selected' : ''}"/>>제목+내용+작성자</option>
	</select>
	<input type="text" id="skeyword" value='<c:out value="${pageMaker.dto.keyword}"/>'/>
	 
	 <form id='actionForm' action"/board/list" method='get'>
		<input type="hidden" name="page" class='pageclz' value='${pageMaker.dto.page}'> 
		<input type="hidden" name="amount" value='${pageMaker.dto.amount}'> 
		<input type="hidden" name="type" value='<c:out value="${pageMaker.dto.type}"/>'> 
		<input type="hidden" name="keyword" value='<c:out value="${pageMaker.dto.keyword}"/>'>
		<button id="searchBtn" class="btn btn-primary">검색</button>
	</form>
	</form>
	
	 <!-- 페이징처리  -->
           <div style="display: flex; justify-content: flex-end">
           <ul class="pagination">
           
			<c:if test="${pageMaker.prev}">
   			 <li class="page-item"><a href="${pageMaker.start - 1}" class="page-link">이전</a></li>
			</c:if>
			
			<c:forEach var="num" begin="${pageMaker.start}" end="${pageMaker.end + 1}">
   			 <li class="page-item ${pageMaker.dto.page == num ? 'active' : '' } ">
   			 <a href="${num}" class="page-link">${num}</a></li>   			 
			</c:forEach>
			
			<c:if test="${pageMaker.next}">
   			 <li class="page-item"><a href="${pageMaker.end + 1}" class="page-link">다음</a>
   			 </li>
			</c:if>
			</ul>
          </div>
        </div>
        
<script type="text/javascript">

$(document).ready(function() {
	
	var f1 = $("#f1");
	
	$(".bnoLink").on("click", function(e) {
		
		e.preventDefault();
		
		var bnoValue = $(this).attr("href");
		
		f1.append("<input type='hidden' name='bno' value='"+bnoValue+"'>");
		f1.attr("action", "/board/read");
		f1.submit();
		
	});

	$("#searchBtn").on("click", function() {

		$("input[name='page']").val(1);

		var inputKeyword = $("#skeyword").val();

		$("input[name='keyword']").val(inputKeyword);

		var inputType = $("#stype option:selected").val();

		$("input[name='type']").val(inputType);

		console.log("inputKeyword: ", inputKeyword);
		console.log("inputType: ", inputType);

		f1.submit();
	});
		
		$(".page-item a").on("click", function(e) {
			e.preventDefault();
			
			//console.log('click');
			//console.log('page: '+$(this).attr("href"));
			
			$(".pageclz").val($(this).attr("href"));
			
			f1.submit();
	});
		
		var searchForm = $("#f1");/*검색버튼 이벤트처리342*/
		
		$("#f1 button").on("click", function(e) {
			
			if(!searchForm.find("option:selected").val()) {
				alert("검색범위를 설정해주세요.");
				return false;
			}
			if(!searchForm.find("input[name = 'keyword']").val()) {
				alert("검색어를 입력해주세요.");
				return false;
			}
			searchForm.find("input[name='page']").val("1");
			e.preventDefault();
			
			searchForm.submit();
			
		});
		
		var result = '<c:out value="${result}"/>';
		
		checkModal(result);
		
		history.replaceState({},null,null);
		
		function checkModal(result) {
			if(result === '' || history.state) {
				return;
			}
			if(parseInt(result) > 0) {
				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
			}
			$("#myModal").modal("show");
		}
		
		$("#regBtn").on("click", function() { //등록버튼 클릭시 url이동
			
			self.location = "/board/register";
				
		});
		
			 $(".LogoutBtn").on("click", function() {
				/* log.info("Go LogoutPage...."); */
				console.log("go LogoutPage....");
				self.location = "/customLogout";
			});
			
			 $(".LoginBtn").on("click", function() {
				 /* log.info("Go LoginPage....");  */
				console.log("go LoginPage....");
				self.location = "/customLogin";
			});  
});
		
</script> 
</html>       

<%@include file="../includes/footer.jsp" %>



