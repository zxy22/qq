<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%
	response.setHeader("X-Frame-Options", "SAMEORIGIN");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header"  content="${_csrf.headerName}"/> --%>
<%@include file="/common/easyui.jspf"%>
<link rel="stylesheet" type="text/css" href="${basePath}/static/css/main.css"/>
<title>首页图片管理</title>
</head>
<body>
	<!--选项卡-->
	<div class="tab">
		<p class="location">
			<em>当前位置 --
				<span id="dqwz">数据字典管理</span>
			</em>
		</p>
	</div>
	<!--选项卡-->
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false">
        <!-- Begin of toolbar -->
        <div id="courseinfo-toolbar">
            <div class="wu-toolbar-button">
                <form id="choice-search-form" style="display: inline-block">
			                    课程类型：<input class="easyui-combobox" value="--请选择--" id="ctype"/>
			                    课程名称：<input class="easyui-textbox" id="couname"/>
                    <a id="choice-search-btn" class="easyui-linkbutton">搜索</a>
                    <a id="choice-search-reset" class="easyui-linkbutton">重置</a>
                </form>
                <a href="javascript:;" style="text-align: right;" class="easyui-linkbutton" iconAlign="left" iconCls="icon-add" onclick="addImg()"
                   plain="true">添加字典</a>
            </div>

        </div>
        <!-- End of toolbar -->
        <table id="courseinfo-datagrid" toolbar="#courseinfo-toolbar"></table>
        123
        
		<div id="dd">Dialog Content.</div>  
    </div>
</div>
	<script type="text/javascript">
	    $('#ctype').combobox({
	    	url: 'getCtype',
	    	editable: true,//不可编辑，只能选择
	    	valueField: 'dicname',
	        textField: 'dicname'}
	    );	
			/**
		     * Name 载入数据
		     */
		    $('#courseinfo-datagrid').datagrid({
		        url: 'getcourselist',
		        rownumbers: true,
		        singleSelect: true,
		        checkOnSelect:false,
	            selectOncheck:false,
		        pageSize: 10,
		        pagination: true,
		        queryParams: formChoiceJson(),
		        multiSort: true,
		        fitColumns: true,
		        fit: true,
		        columns: [[
		            //{field: '', checkbox: true},
		            {field: 'couname', title: '课程名称', width: 50, sortable: true},
		            {field: 'ctype', title: '课程类型', width: 50, sortable: false},
		            {field: 'credit', title: '学分', width: 100, sortable: false},
		            {field: 'is_delete', title: '是否删除', width: 50, sortable: true,
					  	formatter : function(value,row,index){ 
			                 if(value=='0'){return '否'} 
			                 else {return '是'}
		                }	
		            },
		            {field: 'operate', title: '操作', align:'center',width:$(this).width()*0.1,formatter:function(value, row, index){  
						var str = '<a href="#" name="opera" class="easyui-linkbutton" onclick="deleteDic()" ></a>';  
						return str;  
					}}
				]],
				onLoadSuccess:function(data){  
						$("a[name='opera']").linkbutton({text:'删除',plain:true,iconCls:'icon-cancel'});    
				},
		    });
		    /* 搜索方法*/
		    $("#choice-search-btn").click(function () {
		        //点击搜索
		        $('#courseinfo-datagrid').datagrid({
		            queryParams: formChoiceJson()
		        });
		    });
		    /*重置方法*/
		    $("#choice-search-reset").click(function () {
		        $("#choice-search-form").form('clear');
		        $('#choice-datagrid').datagrid({
		            queryParams: formChoiceJson()
		        });
		    });
		    //将表单数据转为json
		    function formChoiceJson() {
		        var ctype = $("#ctype").val();
		        var couname = $("#couname").val();
		        return {"ctype": ctype, "couname": couname};
		    }
		  	//删除字典
		  	function deleteDic(){
		  		var row = $('#courseinfo-datagrid').datagrid('getSelections');
		  		alert(row[0].dicname);
		  		var data = {"dicname": row[0].dicname}
		  		$.messager.confirm('确认', '确认删除?', function () {
				  		$.ajax({
							type: 'post',
							url: 'deleteDic?dicname='+row[0].dicname,
							contentType: "application/json",    //必须配置
							success: function(result){
								$.messager.show({
									title: '提示',
									msg: '数据删除成功。'
								});
							},
				  			error: function(error){
				  				alert("删除失败");
				  			}
						});
				  		$('#courseinfo-datagrid').datagrid('reload');
		  		});
		  	}
	</script>
</body>
</html>