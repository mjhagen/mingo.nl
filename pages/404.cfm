<cfheader statuscode="404" statustext="Not Found" />
<cfset local.title = "Page not found" />
<cfoutput>
  <h1 class="row">#local.title#</h1>
  <p>Missing page: #local.page#</p>
</cfoutput>