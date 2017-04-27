<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title><cfoutput>#rc.title#</cfoutput></title>
    <cfif len( rc.description )><meta name="description" content="<cfoutput>#rc.description#</cfoutput>"></cfif>
    <cfif len( rc.keywords )><meta name="keywords" content="<cfoutput>#rc.keywords#</cfoutput>"></cfif>

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="/static/css/main.css">
  </head>
  <body>
    <div class="container-fluid"><cfoutput>#rc.body#</cfoutput></div>
    <script src="//use.typekit.net/ldb5yfa.js"></script>
    <script>try{Typekit.load({ async: true });}catch(e){};(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','/static/js/analytics.js','ga');ga('create', 'UA-4591808-1', 'auto');ga('send', 'pageview');</script>
  </body>
</html>