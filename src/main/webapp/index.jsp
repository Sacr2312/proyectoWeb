<%@include file="lib/header.jsp"%>

<div>
    <<img src="./images/channels4_banner.jpg" alt="Banner del proyeto"/>
</div>
    

        <h1>PRIMER PROGRAMA WEB EN JSP</h1>
        <br>
        <h3>Cuerpo de pagina index</h3>
        <%
            int edad= 15;
            System.out.print(edad);
        %>
        <div class="container"> 
            <form action= "registro.jsp" method="GET">
                <button type="submit" class="btn btn-primary"> Registrar Usuario</Button>
                
            </form>
<%@include file = "lib/footer.jsp"%>
