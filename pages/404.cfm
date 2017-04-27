<cfheader statuscode="404" statustext="Not Found" />
<cfset rc.title = "Page not found" />
<cfoutput>
  <h1>#rc.title#</h1>
  <p>Missing page: #rc.page#</p>
</cfoutput>