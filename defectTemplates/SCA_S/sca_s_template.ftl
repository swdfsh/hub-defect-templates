<#macro tableRowIfParamIsNotEmptyString name param>
    <#if param!="">
        <tr>
            <th>${name}</th>
            <td>${param}</td>
        </tr>
    </#if>
</#macro>
<#macro tableRowIfParamIsNotEmptyDateTime name param>
    <#if param??>
        <tr>
            <th>${name}</th>
            <td>${param}</td>
        </tr>
    </#if>
</#macro>
<#macro tableRowIfParamIsNotEmptyIdName name param1 param2>
    <#if param1?? && param2!="">
        <tr>
            <th>${name}</th>
            <td>#${param1}: ${param2}</td>
        </tr>
    </#if>
</#macro>
<h3>Scan target info:</h3>
<#assign firstIssue=issues?sort_by(['lastScan','date'])?reverse[0]>
<#if firstIssue.lastScan.scanTarget?size != 0>
    <table>
        <#list firstIssue.lastScan.scanTarget as target>
            <@tableRowIfParamIsNotEmptyDateTime name="Scan date" param=firstIssue.lastScan.date?datetime/>
            <@tableRowIfParamIsNotEmptyIdName name="Scan target" param1=firstIssue.scanObject.id param2=firstIssue.scanObject.name />
            <@tableRowIfParamIsNotEmptyString name="Branch" param=target.branch/>
            <@tableRowIfParamIsNotEmptyString name="Commit" param=target.commit/>
            <@tableRowIfParamIsNotEmptyString name="Version" param=target.version/>
            <@tableRowIfParamIsNotEmptyString name="Build" param=target.build/>
            <@tableRowIfParamIsNotEmptyString name="Target URL" param=target.url/>
        </#list>
        <@tableRowIfParamIsNotEmptyString name="Initiator" param=firstIssue.lastScan.initiator/>
        <@tableRowIfParamIsNotEmptyString name="Environment" param=firstIssue.lastScan.environment/>
    </table>
<#else>
    <#assign scanObject=firstIssue.scanObject>
    <table>
        <@tableRowIfParamIsNotEmptyIdName name="Scan target" param1=scanObject.id param2=scanObject.name/>
    </table>
</#if>

<h3>Issues brief info:</h3>
<#if issues?size gt 1>
    <table>
        <tr>
            <th>ID</th>
            <th>Component</th>
            <th>Severity</th>
            <th>Tool</th>
            <th>Vulnerability</th>
            <#if issues[0].foundBy=="trivy" || issues[0].foundBy=="code-scoring">
                <th>Fix Version</th>
            </#if>
        </tr>

        <#list issues?sort_by("severity") as issue>
            <tr>
                <td><a href="${issue.link}">${issue.id}</a></td>
                <td>${issue.title}</td>
                <td>${issue.severity}</td>
                <td><a href="${issue.externalLink}">${issue.foundBy}</a></td>
                <td><a href="${issue.cve.link}">${issue.cve.id}</a></td>
                <#if issue.foundBy=="trivy" || issue.foundBy=="code-scoring">
                    <td>${issue.fixVersion}</td>
                </#if>
            </tr>
        </#list>
    </table>
</#if>
<#if issues?size == 1>
    <#list issues?sort_by("severity") as issue>
        <p>ID: <a href="${issue.link}">${issue.id}</a></p>
        <p>Component: ${issue.title}</p>
        <p>Severity: ${issue.severity}</p>
        <p>Tool: <a href="${issue.externalLink}">${issue.foundBy}</a></p>
        <p>Vulnerability: <a href="${issue.cve.link}">${issue.cve.id}</a></p>
        <#if issue.foundBy=="trivy" || issue.foundBy=="code-scoring"><p>Fix version: ${issue.fixVersion}</p></#if>
    </#list>
</#if>

<h3>Issues detailed info:</h3>
<table>
    <tr>
        <th>ID</th>
        <th>Description</th>
    </tr>
    <#list issues?sort_by("severity") as issue>
        <tr>
            <td><a href="${issue.link}">${issue.id}</a></td>
            <td>${issue.description}</td>
        </tr>
    </#list>
</table>