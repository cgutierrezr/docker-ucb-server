<%--
- Licensed Materials - Property of IBM Corp.
- IBM UrbanCode Build
- (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
-
- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
- GSA ADP Schedule Contract with IBM Corp.
--%>
<%@ page import="com.urbancode.ubuild.domain.agentfilter.AgentFilter"%>
<%@ page import="com.urbancode.ubuild.domain.agentfilter.agentpool.AgentPoolFilter"%>
<%@ page import="com.urbancode.ubuild.domain.property.PropertyInterfaceTypeEnum"%>
<%@ page import="com.urbancode.ubuild.domain.workflow.WorkflowProperty"%>
<%@ page import="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>

<%@taglib prefix="error" uri="error"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="ucf" tagdir="/WEB-INF/tags/form"%>
<%@taglib prefix="ah3" uri="http://www.urbancode.com/anthill3/tags"%>
<%@taglib prefix="ub"  uri="http://www.urbancode.com/ubuild/tags" %>
<%@taglib prefix="uiA" tagdir="/WEB-INF/tags/ui/admin/agentPool" %>
<ah3:useConstants class="com.urbancode.ubuild.web.WebConstants" />
<ah3:useTasks class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" />
<ah3:useTasks id="WorkflowTasksNoConversation" class="com.urbancode.ubuild.web.admin.project.workflow.WorkflowTasks" useConversation="false" />

<c:set var="inEditMode" value="${fn:escapeXml(mode) == 'edit'}" />
<c:set var="inViewMode" value="${!inEditMode}" />
<c:set var="displayNone" value="style='display: none;'"/>

<c:url var="saveUrl" value="${WorkflowTasks.saveProperty}" />
<c:url var="cancelUrl" value="${WorkflowTasks.cancelProperty}">
  <c:if test="${param.projectTemplatePropSeq != null}">
    <c:param name="projectTemplatePropSeq" value="${param.projectTemplatePropSeq}" />
  </c:if>
</c:url>

<c:url var="editUrl" value="${WorkflowTasksNoConversation.editProperty}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}" />
  <c:if test="${param.projectTemplatePropSeq != null}">
    <c:param name="projectTemplatePropSeq" value="${param.projectTemplatePropSeq}" />
  </c:if>
</c:url>

<c:url var="viewUrl" value="${WorkflowTasks.viewProperty}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}" />
</c:url>

<c:url var="viewListUrl" value="${WorkflowTasks.viewWorkflow}">
  <c:param name="${WebConstants.WORKFLOW_ID}" value="${workflow.id}" />
</c:url>

<jsp:useBean id="eo" class="com.urbancode.ubuild.web.util.EvenOdd" />

<%-- CONTENT --%>
<style type="text/css">

.propertyValueType {
    background-color: white;
	-webkit-box-shadow: 0px 0px 5px 1px rgba(0, 0, 0, .15);
    box-shadow: 0px 0px 5px 1px rgba(0, 0, 0, .15);
    float: left;
    margin-right: 10px;
    padding: 10px;
    width: 250px;
}

</style>
<%
    List<PropertyInterfaceTypeEnum> enumList = PropertyInterfaceTypeEnum.getEnumList();
    Collections.sort(enumList);
    pageContext.setAttribute("enumList", enumList);
    pageContext.setAttribute("newline", "\n");

    WorkflowProperty workflowProp = (WorkflowProperty) pageContext.findAttribute("workflowProp");
    if (workflowProp != null) {
        pageContext.setAttribute("inputPropString", StringUtils.join(workflowProp.getInputProperties(), "\n"));
        pageContext.setAttribute("agentFilter", workflowProp.getJobExecutionAgentFilter());
    }
%>

<error:template page="/WEB-INF/snippets/errors/error.jsp" />


<script type="text/javascript">
    var textType = <%= PropertyInterfaceTypeEnum.TEXT.getId() %>;
    var textAreaType = <%= PropertyInterfaceTypeEnum.TEXT_AREA.getId() %>;
    var textSecureType = <%= PropertyInterfaceTypeEnum.TEXT_SECURE.getId() %>;
    var checkboxType = <%= PropertyInterfaceTypeEnum.CHECKBOX.getId() %>;
    var selectType = <%= PropertyInterfaceTypeEnum.SELECT.getId() %>;
    var multiSelectType = <%= PropertyInterfaceTypeEnum.MULTI_SELECT.getId() %>;
    var pluginSelectType = <%= PropertyInterfaceTypeEnum.PLUGIN.getId() %>;
    var agentPoolType = <%= PropertyInterfaceTypeEnum.AGENT_POOL.getId() %>;

    var pluginMap = {};

    function updateFieldDisplay() {
        var propertyTypeId = Number($('propertyTypeSelect').value);

        $('checkboxFields').hide();
        $('multiSelectFields').hide();
        $('textAndSelectFields').hide();
        $('textAreaFields').hide();
        $('textSecureFields').hide();
        $('pluginTypeFields').hide();
        $('propertyGroupFields').hide();
        $('agentPoolFields').hide();

        if ($('isUserMayOverride').checked) {
            $('fixedValueDiv').hide();
            $('displayTypeFields').show();
            $('definedValueDiv').show();
            $('scriptedValueDiv').show();
            $('jobValueDiv').show();
            if ($('definedValue').checked) {
                var saveToBuildConfig = $('saveToBuildConfigField');
                saveToBuildConfig.show();
                saveToBuildConfig.checked = "${param['saveToBuildConfig'] != null ? param['saveToBuildConfig'] : workflowProp.saveToBuildConfig}";

                //console.log("change to " + propertyTypeId);
                $('scriptedValueFields').hide();
                $('jobValueFields').hide();
                if (propertyTypeId === checkboxType) {
                    $('checkboxFields').show();
                }
                else if (propertyTypeId === textType
                        || propertyTypeId === selectType) {
                    //console.log("showing textAndSelectFields");
                    $('textAndSelectFields').show();
                }
                else if (propertyTypeId === multiSelectType) {
                    $('multiSelectFields').show();
                }
                else if (propertyTypeId === textAreaType) {
                    $('textAreaFields').show();
                }
                else if (propertyTypeId === textSecureType) {
                    $('textSecureFields').show();
                    saveToBuildConfig.hide();
                }
                else if (propertyTypeId === pluginSelectType) {
                    $('pluginTypeFields').show();
                    $('propertyGroupFields').show();
                }
                else if (propertyTypeId === agentPoolType) {
                    $('agentPoolFields').show();
                }

            }
            else if ($('scriptedValue').checked) {
                $('scriptedValueFields').show();
                $('jobValueFields').hide();
            }
            else if ($('jobValue').checked) {
                $('scriptedValueFields').hide();
                $('jobValueFields').show();
            }

            if (propertyTypeId === selectType || propertyTypeId === multiSelectType) {
                if ($('jobValue').checked) {
                    $('allowedValuesScriptFields').hide();
                    $('allowedValuesFields').hide();
                }
                else if ($('scriptedValue').checked) {
                    $('allowedValuesScriptFields').show();
                    $('allowedValuesFields').hide();
                }
                else {
                    $('allowedValuesFields').show();
                    $('allowedValuesScriptFields').hide();
                }
            }
            else {
                $('allowedValuesFields').hide();
                $('allowedValuesScriptFields').hide();
            }

            if (propertyTypeId === checkboxType) {
                $('valueRequiredFields').hide();
            }
            else {
                $('valueRequiredFields').show();
            }
        }
        else {
            $('displayTypeFields').hide();
            $('definedValueDiv').hide();
            $('scriptedValueDiv').hide();
            $('jobValueDiv').hide();
            $('scriptedValueFields').hide();
            $('jobValueFields').hide();
            $('allowedValuesFields').hide();
            $('allowedValuesScriptFields').hide();
            $('valueRequiredFields').hide();
            $('fixedValueDiv').show();
            $('saveToBuildConfigField').hide();
            $('pluginTypeFields').hide();
            $('propertyGroupFields').hide();
            $('agentPoolFields').hide();
        }
    }

    function populatePluginTypeList() {
        var option = null;
        var list = new Array();

        // Create a default option
        var defaultOption = document.createElement("option");
        var makeSelection = i18n("MakeSelection");
        defaultOption.text = '-- ' + makeSelection + ' --';
        defaultOption.value = '';

        // Create a default empty list for when no plugin type is selected
        list.push(defaultOption.cloneNode(true));
        pluginMap[""] = list;

        // For each plugin type, create a list of property groups to select from
        <c:forEach var="entry" items="${pluginMap}">
            list = new Array();
            list.push(defaultOption.cloneNode(true));

            <c:forEach var="propSheet" items="${entry.value}">
                option = document.createElement("option");
                option.text = "${ah3:escapeJs(propSheet.name)}";
                option.value = "${ah3:escapeJs(propSheet.id)}";
                list.push(option);
            </c:forEach>
            pluginMap["${entry.key}"] = list;
        </c:forEach>
    }

    function initPluginList() {
        var pluginType = $('pluginTypeSelect');
        var selectedIndex = pluginType.selectedIndex;
        var selectedTypeId = selectedIndex == null ? null : pluginType.options[selectedIndex].value;

        var propertyGroupSelect = $('propertyGroupSelect');
        for (var oldOption in propertyGroupSelect.options) {
            propertyGroupSelect.remove(oldOption);
        }

        for (var i = 0; i < pluginMap[selectedTypeId].length; i++) {
            propertyGroupSelect.add(pluginMap[selectedTypeId][i], null);
        }

        var selectedValue = "${ah3:escapeJs(param['propertyGroupList'] != null ? param['propertyGroupList'] : workflowProp.displayValue)}";
        propertyGroupSelect.value = selectedValue;
    }

    function updatePluginList() {
        initPluginList();
        var propertyGroupSelect = $('propertyGroupSelect');
        propertyGroupSelect.value = "";
    }

    Element.observe(window, 'load', function() {
       updateFieldDisplay();
       populatePluginTypeList();
       initPluginList();
    });
</script>

<a id="property"></a>

<div class="tab-content">

  <div align="right">
    <span class="required-text">${ub:i18n("RequiredField")}</span>
  </div>

  <form method="post" action="${fn:escapeXml(saveUrl)}#property">
    <c:if test="${param.projectTemplatePropSeq != null}">
      <input type="hidden" name="${WebConstants.PROJECT_TEMPLATE_PROP_SEQ}"
        value="${fn:escapeXml(param.projectTemplatePropSeq)}" />
    </c:if>

    <table class="property-table">
      <tbody>
        <c:set var="fieldName" value="${WebConstants.NAME}"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.name}"/>
        <error:field-error field="${WebConstants.NAME}" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("NameWithColon")} <span class="required-text">*</span></span></td>

          <td width="15%"><ucf:text name="${WebConstants.NAME}" value="${value}"
              enabled="${inEditMode}" /></td>

          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyNameDesc")}</span></td>
        </tr>

        <c:set var="fieldName" value="${WebConstants.DESCRIPTION}"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.description}"/>
        <error:field-error field="${WebConstants.DESCRIPTION}" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("DescriptionWithColon")}</span></td>

          <td colspan="2"><ucf:textarea name="${WebConstants.DESCRIPTION}"
              value="${value}" enabled="${inEditMode}" /></td>
        </tr>

        <c:set var="fieldName" value="isUserMayOverride"/>
        <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.userMayOverride}"/>
        <error:field-error field="isUserMayOverride" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("PropertyUserOverride")}</span></td>

          <td width="15%"><ucf:checkbox name="isUserMayOverride"
              id="isUserMayOverride"
              checked="${value}"
              enabled="${inEditMode}"
              onclick="updateFieldDisplay();"/></td>
          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyUserOverrideDesc")}</span></td>
        </tr>

        <tbody id="saveToBuildConfigField">
          <c:set var="fieldName" value="saveToBuildConfig"/>
          <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.saveToBuildConfig}"/>
          <error:field-error field="saveToBuildConfig" cssClass="${eo.next}" />
          <tr class="${fn:escapeXml(eo.last)}">
            <td width="15%"><span class="bold">${ub:i18n("PropertySaveBuildConfig")}</span></td>

            <td width="15%"><ucf:checkbox name="saveToBuildConfig"
                checked="${value}"
                enabled="${inEditMode}" /></td>
            <td align="left"><span class="inlinehelp">${ub:i18n("PropertySaveBuildConfigDesc")}</span></td>
          </tr>
        </tbody>
      </tbody>
      <tbody id="displayTypeFields" ${workflowProp.userMayOverride ? '' : displayNone}>
        <c:set var="fieldName" value="label"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.label}"/>
        <error:field-error field="label" cssClass="${eo.next}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%"><span class="bold">${ub:i18n("LabelWithColon")} </span></td>

          <td width="15%"><ucf:text name="label" value="${value}" enabled="${inEditMode}" /></td>

          <td align="left"><span class="inlinehelp">${ub:i18n("PropertyLabelDesc")}</span></td>
        </tr>

        <c:set var="fieldName" value="${WebConstants.PROPERTY_TYPE}"/>
        <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.interfaceType.id}"/>
        <error:field-error field="${WebConstants.PROPERTY_TYPE}" cssClass="${eo.next}" />
        <tr valign="top" class="${eo.last}">
          <td align="left" width="15%"><span class="bold">${ub:i18n("PropertyDisplayTypeWithColon")} <span
              class="required-text">*</span></span></td>
          <td align="left" width="15%"><ucf:idSelector name="${WebConstants.PROPERTY_TYPE}" id="propertyTypeSelect"
              list="${enumList}" selectedId="${value}" canUnselect="false"
              onChange="updateFieldDisplay();" /></td>
          <td align="left"><span class="inlinehelp">
              <span class="bold">${ub:i18n("Agent Pool")}</span>
              - ${ub:i18n("PropertyAgentPoolTypeDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Checkbox")}</span>
              - ${ub:i18n("PropertyCheckboxDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Integration Plugin")}</span>
              - ${ub:i18n("PropertyIntegrationPluginDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Multi-Select")}</span>
              - ${ub:i18n("PropertyMultiSelectDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Select")}</span>
              - ${ub:i18n("PropertySelectDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text")}</span>
              - ${ub:i18n("PropertyTextDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text (secure)")}</span>
              - ${ub:i18n("PropertyTextSecureDesc")}
              <br /> <br /> <span class="bold">${ub:i18n("Text Area")}</span>
               - ${ub:i18n("PropertyTextAreaDesc")}
              <br />
          </span></td>
        </tr>
      </tbody>
      <error:field-error field="${WebConstants.PLUGIN_LIST}" cssClass="${eo.next}" />
      <tbody id="pluginTypeFields" ${workflowProp.interfaceType.integrationPlugin ? '' : displayNone}>
        <c:set var="fieldName" value="pluginTypeList"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.pluginType}"/>
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PluginTypeWithColon")} </span></td>

          <td width="15%" style="border-top: 0px;">
            <ucf:idSelector list="${pluginTypeList}"
                            id="pluginTypeSelect"
                            selectedId="${value}"
                            name="pluginTypeList"
                            canUnselect="false"
                            onChange="updatePluginList();"/>
          </td>

          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyPluginTypeDesc")}</span></td>
        </tr>
      </tbody>
      <tbody id="valueFields">
        <tr class="${fn:escapeXml(eo.next)}">
          <td width="15%" style="border-bottom: 0px;"><span class="bold">${ub:i18n("ValueWithColon")} </span></td>

          <td colspan="2" style="border-bottom: 0px;">
            <div id="definedValueDiv" class="propertyValueType" ${workflowProp.userMayOverride ? '' : displayNone}>

              <c:set var="fieldName" value="valueSource"/>
              <c:choose>
                <c:when test="${not empty param[fieldName]}">
                  <c:if test="${param[fieldName] == 'defined'}">
                    <c:set var="defined" value="true"/>
                  </c:if>
                  <c:if test="${param[fieldName] == 'scripted'}">
                    <c:set var="scripted" value="true"/>
                  </c:if>
                  <c:if test="${param[fieldName] == 'job'}">
                    <c:set var="job" value="true"/>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <c:if test="${!workflowProp.scriptedValue}">
                    <c:set var="defined" value="true"/>
                  </c:if>
                  <c:if test="${workflowProp.scriptedValue}">
                    <c:set var="scripted" value="true"/>
                  </c:if>
                  <c:if test="${workflowProp.jobExecutionValue}">
                    <c:set var="job" value="true"/>
                  </c:if>
                </c:otherwise>
              </c:choose>

              <div style="float: left;">
                <input type="radio" id="definedValue" name="valueSource" value="defined" class="radio"
                  <c:if test="${defined}">checked=""</c:if> onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("PropertyDefined")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyDefinedDesc")}</div>
            </div>
            <div id="scriptedValueDiv" class="propertyValueType" ${workflowProp.userMayOverride ? '' : displayNone}>
              <div style="float: left;">
                <input type="radio" id="scriptedValue" name="valueSource" value="scripted" class="radio"
                  <c:if test="${scripted}">checked=""</c:if> onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("Scripted")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyScriptedDesc")}</div>
            </div>
            <div id="jobValueDiv" class="propertyValueType" ${workflowProp.userMayOverride ? '' : displayNone}>
              <div style="float: left;">
                <input type="radio" id="jobValue" name="valueSource" value="job" class="radio"
                  <c:if test="${job}">checked=""</c:if>
                  onclick="updateFieldDisplay();" />
              </div>
              <div style="position: absolute; margin-left: 25px;">
                <span class="bold">${ub:i18n("JobExecution")}</span>
              </div>
              <br />
              <div style="margin-top: 5px; margin-left: 25px;">${ub:i18n("PropertyJobExecutionDesc")}</div>
            </div>
            <div id="fixedValueDiv" ${workflowProp.userMayOverride ? displayNone : ''}>
              <c:set var="fieldName" value="fixedValue"/>
              <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
              <ucf:text name="fixedValue" value="${value}"/>
            </div>
          </td>

        </tr>
      </tbody>
        <!-- TRANSLATE STARTING HERE -->
      <tbody id="valueRequiredFields" ${not workflowProp.interfaceType.checkbox && workflowProp.userMayOverride ? '' : displayNone}>
        <c:set var="fieldName" value="isRequired"/>
        <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.required}"/>
        <error:field-error field="isRequired" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyValueRequiredWithColon")} </span></td>

          <td width="15%" style="border-top: 0px;"><input type="checkbox" class="checkbox" name="isRequired" value="true"<c:if test="${value}">checked="checked"</c:if>>
          </td>

          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyValueRequiredDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="isSelect"
        value="${workflowProp.interfaceType.select or workflowProp.interfaceType.multiSelect}" />
      <c:set var="hideAllowedValues"
        value="${!isSelect or workflowProp.scriptedValue or workflowProp.jobExecutionValue}" />
      <tbody id="allowedValuesFields" ${hideAllowedValues ? displayNone : ''}>
        <c:set var="fieldName" value="allowedValues"/>
        <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.allowedValues}"/>
        <error:field-error field="allowedValues" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AllowedValuesWithColon")} <span
              class="required-text">*</span></span></td>

          <td colspan="2" style="border-top: 0px;"><c:remove var="allowedValuesString" /> <c:forEach var="allowedValue"
              items="${value}">
              <c:if test="${not empty allowedValuesString}">
                <c:set var="allowedValuesString" value="${allowedValuesString}${newline}" />
              </c:if>

              <c:set var="allowedValuesString" value="${allowedValuesString}${allowedValue}" />
            </c:forEach> <ucf:textarea name="allowedValues" value="${allowedValuesString}" cols="60" rows="5"
              enabled="${inEditMode}" /><br /> <span class="inlinehelp">${ub:i18n("PropertyAllowedValuesDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="hideAllowedValuesScript" value="${!isSelect and not workflowProp.scriptedValue}" />

      <tbody id="allowedValuesScriptFields" ${hideAllowedValuesScript ? displayNone : ''}>
        <error:field-error field="allowedValuesScript" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyAllowedValuesScriptWithColon")} <span
              class="required-text">*</span></span></td>

          <td colspan="2" style="border-top: 0px;"><c:remove var="allowedValuesString" /> <c:forEach var="allowedValue"
              items="${value}">
              <c:if test="${not empty allowedValuesString}">
                <c:set var="allowedValuesString" value="${allowedValuesString}${newline}" />
              </c:if>

              <c:set var="allowedValuesString" value="${allowedValuesString}${allowedValue}" />
            </c:forEach>
            <c:set var="fieldName" value="allowedValuesScript"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.allowedValuesScript}"/>
            <ucf:textarea name="allowedValuesScript" value="${value}" cols="80"
              rows="10" enabled="${inEditMode}" /><br />
            <div class="inlinehelp">${ub:i18n("PropertyAllowedValuesScriptDesc")}</div></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="checkboxValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="checkboxFields" ${workflowProp.interfaceType.checkbox ? '' : displayNone}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:checkbox name="checkboxValue" value="true"
              checked="${value == 'true'}" enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="textAreaValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="textAreaFields" ${workflowProp.interfaceType.textArea ? '' : displayNone}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td align="left" colspan="2" style="border-top: 0px;"><ucf:textarea name="textAreaValue"
              value="${value}" cols="60" rows="5" enabled="${inEditMode}" /></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="secureValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="textSecureFields" ${workflowProp.interfaceType.textSecure ? '' : displayNone}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:password name="secureValue" value="${value}"
              enabled="${inEditMode}" size="30" extraAttribs="onKeyUp=\"showLayer('vlConfirm'); this.onkeyup=null;\"" />
            <div id="vlConfirm" <c:if test="${!showConfirm}">style="display: none;"</c:if>>
              ${ub:i18n("Confirm")} <br />
              <ucf:password name="valueConfirm" value="" enabled="${inEditMode}" size="30" />
            </div></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="value"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="textAndSelectFields" ${workflowProp.userMayOverride and (workflowProp.interfaceType.text || workflowProp.interfaceType.select) ? '' : displayNone}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:text name="value" value="${value}"
              enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="multiSelectValue"/>
      <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="multiSelectFields" ${workflowProp.interfaceType.multiSelect ? '' : displayNone}>
        <error:field-error field="value" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("DefaultValueWithColon")}</span></td>
          <td style="border-top: 0px;"><ucf:text name="multiSelectValue" value="${value}"
              enabled="${inEditMode}" /></td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyDefaultValueDescMulti")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="propertyGroupList"/>
      <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="propertyGroupFields" ${workflowProp.interfaceType.integrationPlugin ? '' : displayNone}>
        <error:field-error field="${WebConstants.PLUGIN}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyPropertyGroup")} </span></td>

          <td width="15%" style="border-top: 0px;">
            <ucf:idSelector list="${propertyGroupList}"
                            id="propertyGroupSelect"
                            selectedId="${value}"
                            name="propertyGroupList"
                            canUnselect="false"/>
          </td>

          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyPropertyGroupDesc")}</span></td>
        </tr>
      </tbody>

      <c:set var="fieldName" value="agentPoolList"/>
      <c:set var="value" value="${not empty param[fieldName] ? param[fieldName] : workflowProp.displayValue}"/>
      <tbody id="agentPoolFields" ${projectTemplateProp.interfaceType.agentPool ? '' : 'style="display:none;"'}>
        <error:field-error field="${WebConstants.AGENT_POOL}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AgentPoolWithColon")} </span></td>
          <td width="15%" style="border-top: 0px;">
            <select name="agentPoolList" class="input">
              <option value="">--&nbsp;${ub:i18n("MakeSelection")}&nbsp;--</option>
                <c:forEach var="agentPool" items="${agentPoolList}">
                  <c:set var="agentPoolStr" value="${agentPool.name}" />
                  <option value="${agentPoolStr}" <c:if test="${agentPoolStr eq value}">selected=""</c:if>>
                    <c:out value="${agentPoolStr}" />
                  </option>
                </c:forEach>
            </select>
          </td>
          <td align="left" style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyAgentPoolDefaultDesc")}</span></td>
        </tr>
      </tbody>

      <tbody id="scriptedValueFields" ${workflowProp.scriptedValue ? '' : displayNone}>
        <error:field-error field="valueScript" cssClass="${eo.last}" />
        <error:field-error field="inputProperties" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("PropertyDefaultValueScriptWithColon")}</span></td>

          <td colspan="2" style="border-top: 0px;">
            <c:set var="fieldName" value="inputProperties"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : inputPropString}"/>
            <%-- allow for props of type: text, textArea select, multi-select  --%> <c:if
              test="${workflowProp.interfaceType.multiValued || workflowProp.interfaceType.text || workflowProp.interfaceType.textArea || workflowProp.interfaceType.checkbox}">
              <%--
              <div style="margin: 0em 0em 2em 0em;">
                <span class="bold">${ub:i18n("PropertySourcePropertyNamesWithColon")}</span><br />
                <ucf:textarea name="inputProperties" value="${value}" cols="40" rows="5" />
                <div class="inlinehelp">${ub:i18n("PropertySourcePropertyNamesDesc")}</div>
              </div>
               --%>

              <span class="bold">${ub:i18n("PropertyBeanshellScript")} <c:if
                  test="${not workflowProp.interfaceType.multiValued}">
                  <span class="required-text">*</span>
                </c:if>
              </span>
              <br />
            </c:if>
            <c:set var="fieldName" value="valueScript"/>
            <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.valueScript}"/>
            <ucf:textarea name="valueScript" value="${value}" cols="80" rows="10"
              enabled="${inEditMode}" /><br />
            <div class="inlinehelp">
              ${ub:i18n("PropertyBeanshellScriptDesc1")}
              <ul style="margin: 0px 0px 15px 6px">
                <li>${ub:i18n("PropertyBeanshellScriptDesc2")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc3")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc4")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc5")}</li>
                <li>${ub:i18n("PropertyBeanshellScriptDesc6")}</li>
              </ul>
            </div>
          </td>
        </tr>
      </tbody>

      <tbody id="jobValueFields" ${workflowProp.jobExecutionValue ? '' : displayNone}>
        <error:field-error field="${WebConstants.AGENT_POOL_ID}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("AgentPoolWithColon")} <span class="required-text">*</span>
          </span></td>

          <c:set var="fieldName" value="${WebConstants.AGENT_POOL_ID}"/>
          <c:set var="agentFilterValue" value="${param[fieldName] != null ? param[fieldName] : agentFilter}"/>
          <td style="border-top: 0px;">
            <uiA:agentPoolSelector
                agentFilter="${agentFilterValue}"
                disabled="${inViewMode}"
                allowNoAgent="false"
                allowParentJobAgent="false"
                useRadio="false"
                agentPoolList="${agentPoolList}"
            />
          </td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyAgentPoolDesc")}</span></td>
        </tr>
        <error:field-error field="${WebConstants.JOB_CONFIG_ID}" cssClass="${eo.last}" />
        <tr class="${fn:escapeXml(eo.last)}">
          <td width="15%" style="border-top: 0px;"><span class="bold" style="margin-left: 25px;">${ub:i18n("JobWithColon")} <span
              class="required-text">*</span></span></td>

          <c:set var="fieldName" value="${WebConstants.JOB_CONFIG_ID}"/>
          <c:set var="value" value="${param[fieldName] != null ? param[fieldName] : workflowProp.jobExecutionJobConfig.id}"/>
          <td style="border-top: 0px;">
            <ucf:idSelector
                name="${fn:escapeXml(WebConstants.JOB_CONFIG_ID)}"
                list="${libJobList}"
                selectedId="${value}"/>
          </td>
          <td style="border-top: 0px;"><span class="inlinehelp">${ub:i18n("PropertyWorkflowJobDesc")}</span></td>
        </tr>
      </tbody>

    </table>

    <br />

    <c:if test="${inEditMode}">
      <ucf:button name="Save" label="${ub:i18n('Save')}"/>
      <ucf:button name="Cancel" label="${ub:i18n('Cancel')}" href="${ah3:escapeJs(cancelUrl)}"/>
    </c:if>

    <c:if test="${inViewMode}">
      <ucf:button name="Edit" label="${ub:i18n('Edit')}" href="${editUrl}#property" />
      <ucf:button name="Done" label="${ub:i18n('Done')}" href="${viewListUrl}" />
    </c:if>
  </form>
</div>
