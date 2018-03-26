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
				<span id="dqwz">首页图片管理</span>
			</em>
		</p>
	</div>
	<!--选项卡-->
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false">
        <!-- Begin of toolbar -->
        <div id="imginfo-toolbar">
            <div class="wu-toolbar-button">
                <!-- <a href="javascript:;" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddChoice()"
                   plain="true">添加</a>
                <a href="javascript:;" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditChoice()"
                   plain="true">修改</a>
                <a href="javascript:;" class="easyui-linkbutton" iconCls="icon-remove" onclick="openRemoveChoice()"
                   plain="true">删除</a>
                <a href="javascript:;" class="easyui-linkbutton" iconCls="icon-ok" onclick="openImportChoice()"
                   plain="true">导入</a> -->
                <form id="choice-search-form" style="display: inline-block">
			                    图片名称：<input class="easyui-textbox" id="imgname"/>
                    <a id="choice-search-btn" class="easyui-linkbutton">搜索</a>
                    <a id="choice-search-reset" class="easyui-linkbutton">重置</a>
                </form>
                <a href="javascript:;" style="text-align: right;" class="easyui-linkbutton" iconAlign="left" iconCls="icon-add" onclick="addImg()"
                   plain="true">添加图片</a>
            </div>

        </div>
        <!-- End of toolbar -->
        <table id="imginfo-datagrid" toolbar="#imginfo-toolbar"></table>
    </div>
</div>
	<script type="text/javascript">
		
			/**
		     * Name 载入数据
		     */
		    $('#imginfo-datagrid').datagrid({
		        url: 'getindeximglist',
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
		            {field: 'imgno', title: '图片编号', width: 50, sortable: true},
		            {field: 'imgname', title: '图片名称', width: 50, sortable: false},
		            {field: 'imgurl', title: '图片地址', width: 100, sortable: false},
		            {field: 'create_time', title: '上传时间', width: 180, sortable: true},
		            {field: 'is_pub', title: '是否展示', width: 50, sortable: true,
					  	formatter : function(value,row,index){ 
			                 if(value=='0'){return '否'} 
			                 else {return '是'}
		                }	
		            },
		            {field: 'operate', title: '操作', align:'center',width:$(this).width()*0.1,formatter:function(value, row, index){  
						var str = '<a href="#" name="opera" class="easyui-linkbutton" onclick="deleteImg()" ></a>';  
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
		        $('#imginfo-datagrid').datagrid({
		            queryParams: formChoiceJson()
		        });
		    });
		    /*重置方法*/
		    $("#choice-search-reset").click(function () {
		        $("#choice-search-form").form('clear');
		        $("#imgname").val('');
		        $('#choice-datagrid').datagrid({
		            queryParams: formChoiceJson()
		        });
		    });
		    //将表单数据转为json
		    function formChoiceJson() {
		        var imgname = $("#imgname").val();
		        //alert(question1);
		        //alert(question2);
		        return {"imgname": imgname};
		    }
		  	//删除图片
		  	function deleteImg(){
		  		var row = $('#imginfo-datagrid').datagrid('getSelections');
		  		$.messager.confirm('确认', '确认删除?', function () {
				  		$.ajax({
							type: 'post',
							url: 'deleteIndexImg?imgno=' + row[0].imgno,
							contentType: "application/json",    //必须配置
							success: function(result){
								$.messager.show({
									title: '提示',
									msg: '数据删除成功。'
								});
							} 
						});
				  		$('#imginfo-datagrid').datagrid('reload');
		  		});
		  	}
		  	function addImg(){
		  		showMyWindow("添加图片",  
	                    'goaddindeximg',  
	                    800, 400);
		  	}
		  	$(function() {
		        $('body').append('<div id="myWindow" class="easyui-dialog" closed="true"></div>');  
		    });  
		    function showMyWindow(title, href, width, height, modal, minimizable,  
		            maximizable) {
		        $('#myWindow').window(
                    {
                        title : title,  
                        width : width === undefined ? 800 : width,  
                        height : height === undefined ? 400 : height,  
                        content : '<iframe scrolling="yes" frameborder="0"  src="'  
                                + href  
                                + '" style="width:100%;height:98%;"></iframe>',  
                        modal : modal === undefined ? true : modal,  
                        minimizable : minimizable === undefined ? false  
                                : minimizable,  
                        maximizable : maximizable === undefined ? false  
                                : maximizable,  
                        shadow : false,  
                        cache : false,  
                        closed : false,  
                        collapsible : false,  
                        resizable : false,  
                        loadingMessage : '正在加载数据，请稍等片刻......'  
                    });  
		    }  
	</script>
</body>
</html>