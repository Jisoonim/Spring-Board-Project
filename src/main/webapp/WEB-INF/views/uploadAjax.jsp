<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="UTF-8">
<title>FileUpload Page</title>
</head>
<body>
<h1>Upload with Ajax</h1>
<h2>파일을 업로드 해보세요.</h2>

<div class="uploadDiv">
<input type="file" name="uploadFile" multiple>
</div>

<div class="bigPictureWrapper">
<div class="bigPicture">
</div>
</div>


<button id="uploadBtn">업로드</button>

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

<div class="uploadResult">
<ul>

</ul>
</div>


<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
  
  <script>
  function showImage(fileCallPath) {//원본 이미지 보여주기(클릭시 이미지확대)
  		$(".bigPictureWrapper").css("display", "flex").show();
  
  		$(".bigPicture")
  		
  		.html("<img src='/display?fileName=" +encodeURI(fileCallPath)+"'>")
  		.animate({width :'100%', height :'100%'}, 1000);
  		}
  
  		 $(".bigPictureWrapper").on("click", function(e) { //이미지확대했다가 1초뒤에 꺼지게하기
			 $(".bigPicture").animate({width :'0%', height :'0%'}, 1000);
			 setTimeout(function() {
				 $(".bigPictureWrapper").hide();
			 }, 1000);
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
		
	  var cloneObj = $(".uploadDiv").clone();
	  
	  $("#uploadBtn").on("click", function(e) {
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
		  
		  var uploadResult = $(".uploadResult ul");
		  
		  
		  function showUploadedFile(uploadResultArr) { //첨부파일 아이콘
			  
			  var str = "";
			  
			  $(uploadResultArr).each(function(i, obj) {
				  
				  if (!obj.image) {
					  
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/"); //파일 삭제
					
					/* str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/img/attach.jpg'>"+obj.fileName+"</a></li>"; */
					
				    str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"+
						  "<img src='/resources/img/attach.jpg'>"+obj.fileName+"</a>"+
						  "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"+"</div></li>"; 
						  
					/* str += "<li><img src='/resources/img/attach.jpg'>"+obj.fileName+"</li>"; */ 
				  
				  }else {
					  
					  //str += "<li>" + obj.fileName + "</li>";
				  
				  var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
				  
				  //str += "<li><img src='/display?fileName="+fileCallPath+"'></li>";
				  
				  var originPath = obj.uploadPath+ "\\"+obj.uuid+"_"+obj.fileName;

				   originPath = originPath.replace(new RegExp(/\\/g),"/");
				   
				  /*  str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a></li>"; */
				    
				   str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+ 
				  		"<img src='/display?fileName="+fileCallPath+"'></a>"+
				  		"<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+"</li>";
				  }
			  });
			  
			  uploadResult.append(str);
		  }
		  
		  $(".uploadResult").on("click", "span", function(e) { //x표시(삭제)에 대한 이벤트 처리
			
			  var targetFile = $(this).data("file");
			  var type = $(this).data("type");
			  console.log(targetFile);
			  
			  $.ajax({
				  url: '/deleteFile',
				  data: {fileName: targetFile, type:type},
				  dataType: 'text',
				  type: 'POST',
				  success: function(result) {
					  alert(result); //delete success가 계속반복되서 뜸.
					  console.log(result);
				  }
			  }); //$.ajax
		  });//end function
		  
		  
		  $.ajax({
			  url: '/uploadAjaxAction',
		  	  processData: false,
		  	  contentType: false,
		  	  data: formData,
		  	  type: 'POST',
		  	  dataType:'json',
		  	  success: function(result) {
		  		  	alert("업로드 되었습니다.");
		  		  
		  		  	console.log(result);
		  		  
		 			showUploadedFile(result); //업로드 결과 처리 함수
		  		  
		  	 $(".uploadDiv").html(cloneObj.html());
		  	 
		  	 }
		  }); //$.ajax		  
	  });
  });
  </script>


</body>
</html>