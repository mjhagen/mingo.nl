<cfexecute name="git" arguments="--git-dir=/var/lib/tomcat7/webapps/ROOT/.git --work-tree=/var/lib/tomcat7/webapps/ROOT pull" variable="output" />
<cfoutput>#output#</cfoutput>
Done.
