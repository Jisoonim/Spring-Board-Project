<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!-- Date format -->

<meta charset="UTF-8">
<%@include file="../includes/header.jsp"%>

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
	<h1 class="h3 mb-2 text-gray-800">Board Register</h1>

	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h6 class="m-0 font-weight-bold text-primary">게시글 작성</h6>
		</div>
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable" width="100%"
					cellspacing="0">
					<form role="form" action="/board/register" method="post">
					
					 <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

						<div class="form-group">
							<label>제목</label> <input class="form-control" name="title">
						</div>

						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control" rows="3" name="content"></textarea>
						</div>

						<div class="form-group">
							<label>작성자</label> <input class="form-control" name="writer" 
							value='<sec:authentication property="principal.username"/>' readonly="readonly">
						</div>

						<button type="submit" class="btn btn-success">등록</button>
						<button type="reset" class="btn btn-danger">초기화</button>
						<button type="submit" data-oper='list' class="btn btn-info">목록으로</button>
					</form>
				</table>
			</div>
		</div>
	</div>
</div>

<div class="container-fluid">
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h6 class="m-0 font-weight-bold text-primary">File Attach</h6>
		</div>

		<div class="card-body">
			<div class="form-group uploadDiv">
				<input type="file" name="uploadFile" multiple>
			</div>
			<div class="uploadResult">
				<ul>

				</ul>
			</div>
		</div>
	</div>
</div>

<script>

$(document).ready(function(e) {
	
	var formObj = $("form[role='form']");
	
	$("button[type='submit']").on("click", function(e) {
		
		e.preventDefault();
		
		console.log("submit clicked.....");
		
		var str = "";
		
		$(".uploadResult ul li").each(function(i, obj) {
			
			var jobj = $(obj);
			
			console.dir(jobj);
			
			str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
			
		});
		
		formObj.append(str).submit();
		
	});
});

$(document).ready(function(){
	  
	  //var regex = new RegExp("(.*?)\.(exe|sh|alz|pptx)$"); //확장자 업로드 제한
	  var maxSize = 5242880; //5MB
	  
	  function checkExtension(fileSize) { //파일크기 체크 / fileName, 
		  
		  if(fileSize >= maxSize) {
			  alert("파일 크기를 초과하였습니다.");
			  return false;
		  }
		  
		/*   if(regex.test(fileName)) { //파일 확장자 체크
			  alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			  return false; 
		  } */
		  return true;
	  }
	  
	  var csrfHeaderName = "${_csrf.headerName}";
	  var csrfTokenValue = "${_csrf.token}";
	  
	  $("input[type='file']").change(function(e) {
 		var formData = new FormData();
		  
		  var inputFile = $("input[name='uploadFile']");
		  
		  var files = inputFile[0].files;
		  
		  console.log(files);
		  
		  for(var i = 0; i < files.length; i++) {
			  
			  if(!checkExtension(files[i].name, files[i].size)) {
				  return false;
			  }
			  
			  formData.append("uploadFile", files[i]);
		  }
		  
		  $.ajax({
				 url : '/uploadAjaxAction',
				 processData : false,
				 contentType : false,
				 beforeSend : function(xhr) {
					 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				 },
				 data : formData, 
				 type : 'POST',
				 dataType : 'json',
				 success : function(result) {
					 alert("업로드 되었습니다.");
					 
					 console.log(result);
					 
					 showUploadResult(result); //업로드 결과 처리 함수
					 
					//$(".uploadDiv").html(cloneObj.html());
				 }
		  }); //$.ajax
	  });
	  
	  function showUploadResult(uploadResultArr) {
		  
		  if(!uploadResultArr || uploadResultArr.length == 0) {
			  return;
		  }
		  
		  var uploadUL = $(".uploadResult ul");
		  
		  var str = "";
		  
		  $(uploadResultArr).each(function(i, obj) {
			  
			  if(obj.image) { //파일이 이미지일경우
				  
				  var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
				  
				  str += "<li data-path='"+obj.uploadPath+"'";
				  str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
				  str +" ><div>";
				  str += "<span>"+obj.fileName+"</span>";
				  str += "<button type='button' data-file=\'"+fileCallPath+"\' "
				  str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				  str += "<img src='/display?fileName="+fileCallPath+"'>";
				  str += "</div>";
				  str += "</li>";

			  }else {
				  var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				  var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/"); //파일 삭제
				  
				  str += "<li " //><div>";
				  str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				  str += "<span>"+obj.fileName+"</span>";
				  str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
				  str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				  str += "<img src='/resources/img/attach1.png'></a>";
				  str += "</div>";
				  str += "</li>";
			  }
		  });
		  
		  uploadUL.append(str);
	  } //end showUploadResult
	  
	  $(".uploadResult").on("click", "button", function(e) {//x버튼 클릭시 파일 삭제
		 console.log("delete file click"); 
		 
		 var targetFile = $(this).data("file");
		  var type = $(this).data("type");
		  
		  var targetLi = $(this).closest("li");
		  
		  $.ajax({
			  url: '/deleteFile',
			  data: {fileName: targetFile, type:type},
			  beforeSend : function(xhr) {
				  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			  },
			  
			  dataType: 'text',
			  type: 'POST',
			  success: function(result) {
				  alert(result); //delete success가 계속반복되서 뜸.
				  targetLi.remove();
			  }
		  }); //$.ajax
	  }); //end uploadResult
	  
});

</script>

<%@include file="../includes/footer.jsp"%>
