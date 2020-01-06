<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Login Success.
</h1>

<P>  The time on the server is ${serverTime}. </P>

<script type="text/javascript">

self.location="/board/list";

</script>

</body>
</html>
