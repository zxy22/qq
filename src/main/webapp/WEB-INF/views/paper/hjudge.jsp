<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false"%>
<%@include file="/common/easyui.jspf" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
<body>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false">
        <!-- Begin of toolbar -->
        <div id="judge-toolbar">
            <div class="wu-toolbar-button">
                <form id="judge-search-form" style="display: inline-block">
			                    题目：<input class="easyui-textbox" id="judge-name-value"/>
			                    难度等级：<input class="easyui-textbox" id="judge-degree-value"/>
			                     时间：<input type="date" id="bdaytime-course-value"/>~<input type="date" id="edaytime-course-value"/>
                    <a id="judge-search-btn" class="easyui-linkbutton">搜索</a>
                    <a id="judge-search-reset" class="easyui-linkbutton">重置</a>
                </form>
            </div>
        </div>
        <!-- End of toolbar -->
        <table id="judge-datagrid" toolbar="#judge-toolbar" style="width: 100%;"></table>
    	 已选择内容：
        <div  style="width:99%;height: 150px;overflow:scroll;border: 1px solid;">
        	<table id="singles">
        		<tr><th>题目</th><th>分数</th><th>操作</th></tr>
        	</table>
		</div>
    </div>
</div>
<script type="text/javascript">
    /**
     * Name 载入数据
     */
    $('#judge-datagrid').datagrid({
        url: 'judgement',
        queryParams: formJudgeJson(),
        rownumbers: true,
        singleSelect: false,
        pageSize: 20,
        pagination: true,
        multiSort: true,
        fitColumns: true,
        fit: false,
        columns: [[
            {field: '', checkbox: true},
            {field: 'id', title: '编号', width: 50, sortable: true, hidden: true},
            {field: 'judgmentTitle', title: '题目', width: 180, sortable: true},
            {field: 'judgmentAnswer', title: '正确答案', width: 100,formatter:function(value,row,index) {
            	if(value == "0") {
            		return "错误";
            	} else if (value == "1") {
            		return "正确";
            	}
            }},
            {field: 'degree', title: '难度等级', width: 50},
            {field: '_operate', title: '操作', width: 30,formatter:function(value,row,index){
            	return '<a href="#" onclick="selectTitle('+index+')">选择</a>';
            }}
        ]]
    });
	
 	// 选择题目
    function selectTitle(index) {
    	$('#judge-datagrid').datagrid('selectRow',index);// 关键在这里
        var row = $('#judge-datagrid').datagrid('getSelected');  
    	$("#singles").append("<tr><td><input type='checkbox' checked='checked' style='display:none;' id ='"+row.id+"' value='"+row.id+"'/>"+row.judgmentTitle+"</td><td><input type='text' id ='score"+row.id+"' placeholder='输入分数' name='score' size='4' /></td><td><a href='#' onclick='removeTitle(this);' >删除</a></td></tr>");
    }
    // 删除选择题目
    function removeTitle(nowtr){
        $(nowtr).parent().parent().remove();
    }

    /* 搜索方法*/
    $("#judge-search-btn").click(function () {
        //点击搜索
        $('#judge-datagrid').datagrid({
            queryParams: formJudgeJson()
        });
    });

    /*重置方法*/
    $("#judge-search-reset").click(function () {
        $("#judge-search-form").form('clear');
        $("#bdaytime-course-value").val('');
        $("#edaytime-course-value").val('');
        // 重新加载数据
        $('#judge-datagrid').datagrid({
            queryParams: formJudgeJson()
        });
    });

    //将表单数据转为json
    function formJudgeJson() {
        var bJudgeName = $("#judge-name-value").val();
        var degree = $("#judge-degree-value").val();
        var bTime = $("#bdaytime-course-value").val();
        var eTime = $("#edaytime-course-value").val();
        return {"judgename": bJudgeName,"degree":degree, "bTime": bTime,"eTime":eTime};
    }

    /**
     * 创建课程的下拉框
     */
    $('#courseId').combobox({
        url: 'courseServlet.do?method=getCourseByUserId',
        valueField: 'id',
        textField: 'name',
        panelMaxHeight: '100',
    });
</script>
</body>
</html>