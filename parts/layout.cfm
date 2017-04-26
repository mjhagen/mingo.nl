<cfparam name="local.title" default="" />
<cfparam name="local.description" default="" />
<cfparam name="local.keywords" default="" />
<cfparam name="local.body" default="" />

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title><cfoutput>#local.title#</cfoutput></title>

    <meta name="description" content="<cfoutput>#local.description#</cfoutput>" />
    <meta name="keywords" content="<cfoutput>#local.keywords#</cfoutput>" />
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="//mingo-nl.no-cookies.com/css/main.css" />

    <script data-cfasync="false" type="text/javascript" src="http://use.typekit.com/ldb5yfa.js"></script>
    <script data-cfasync="false" type="text/javascript">try{Typekit.load();}catch(e){}</script>
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//mingo-nl.no-cookies.com/js/analytics.js','ga');
      ga('create', 'UA-4591808-1', 'auto');
      ga('send', 'pageview');
    </script>
  </head>
  <body>
    <div class="container-fluid"><cfoutput>#local.body#</cfoutput></div>
    <div id="server"><cfoutput>#cgi.local_host#</cfoutput></div>
  </body>
</html>
