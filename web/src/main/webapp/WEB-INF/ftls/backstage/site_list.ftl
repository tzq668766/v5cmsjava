<#include "fragment/head.ftl">
<!-- Right side column. Contains the navbar and content of the page -->
<aside class="right-side">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            站点管理
            <small>Control panel</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> 首页</a></li>
            <li>站点设置</li>
            <li class="active">站点管理</li>
        </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <!-- Small boxes (Stat box) -->
        <div class="row">
            <div class="box box-danger">
                <div class="box-header">
                    <!-- tools box -->
                    <div class="pull-right box-tools">
                        <button id="addSite" class="btn btn-success btn-sm" data-toggle="tooltip" title="添加站点">
                            <i class="fa fa-plus"></i> 添加站点</button>
                        <button id="siteBatchDelete" class="btn btn-warning btn-sm" data-toggle="tooltip" title="批量删除">
                            <i class="fa fa-trash-o"></i> 批量删除</button>
                    </div><!-- /. tools -->
                    <i class="fa fa-table"></i>
                    <h3 class="box-title">站点信息表</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body table-responsive">
                    <table class="table table-hover table-bordered table-striped">
                        <colgroup>
                            <col class="col-xs-1 v5-col-xs-1">
                            <col class="col-xs-2">
                            <col class="col-xs-3">
                            <col class="col-xs-2">
                            <col class="col-xs-2">
                            <col class="col-xs-2">
                        </colgroup>
                        <thead>
                        <tr>
                            <th class="td-center">
                                <input type="checkbox" id="thcheckbox"/>
                            </th>
                            <th>序号</th>
                            <th>名称</th>
                            <th>状态</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#if sites?size != 0>
                            <#list sites as site>
                            <tr>
                                <td class="td-center">
                                    <input type="checkbox" class="table-cb" value="${site.siteId}"/>
                                </td>
                                <td>${site.siteId}</td>
                                <td>${site.siteName}</td>
                                <td>
                                    ${(site.isclosesite==1)?string("<small class='badge bg-green'>正常</small>",
                                    "<small class='badge bg-red'>关闭</small>")}
                                </td>
                                <td>${site.createDate?string("yyyy-MM-dd")}</td>
                                <td>
                                    <a href="<@spring.url '/manager/site/update/${site.siteId}'/>">修改</a>&nbsp;&nbsp;
                                    <a href="javascript:;" class="deletesite" data-siteid="${site.siteId}">删除</a>
                                </td>
                            </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="5"><h3>还没有站点数据！</h3></td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>
        <!-- /.row -->

    </section>
    <!-- /.content -->
</aside><!-- /.right-side -->
<#include "fragment/footer.ftl">
<script type="text/javascript">
    $(function(){
        $("#nav_siteSetting").imitClick();
        $("#addSite").click(function(){
            location.href="<@spring.url '/manager/site/edit'/>";
        });

        function deleteSites(siteIds) {
            $.v5cms.confirm({icon:"question",content:"您确定要删除站点信息吗，删除后将不能恢复？",width:350,ok:function(){
                var url = "<@spring.url '/manager/site/delete'/>";
                $.ajax({
                    dataType:'json',
                    type:'POST',
                    url:url,
                    data:{siteIds:siteIds},
                    success:function(data){
                        if(data.status == "1"){
                            $.v5cms.tooltip({icon:"succeed","content":data.message},function(){
                                location.reload();
                            });
                        }else{
                            $.v5cms.tooltip({icon:"error","content":data.message},function(){});
                        }
                    },
                    error:function(XMLHttpRequest, textStatus, errorThrown){
                        $.v5cms.tooltip({icon:"error","content":"删除站点出错，"+textStatus+"，"+errorThrown});
                    }
                });
                /*$.post(url,{siteIds:siteIds},function(data){
                    if(data.status == "1"){
                        $.v5cms.tooltip({icon:"succeed","content":data.message},function(){
                            location.reload();
                        });
                    }else{
                        $.v5cms.tooltip({icon:"error","content":data.message},function(){
                            location.reload();
                        });
                    }
                },"json");*/
            }});
        }

        $(".deletesite").click(function(){
            var siteId = $(this).data("siteid");
            deleteSites(siteId);
        });

        $("#thcheckbox").on('ifChecked', function(event){
            $('.table-cb').iCheck('check');
        });
        $("#thcheckbox").on('ifUnchecked', function(event){
            $('.table-cb').iCheck('uncheck');
        });

        $("#siteBatchDelete").click(function(){
            var $chs = $(":checkbox[checked=checked]");
            if($chs.length == 0){
                $.v5cms.tooltip({icon:"warning","content":"您还没有选中要操作的数据项！"},function(){});
                return;
            }
            var siteIds = [];
            for(var i=0;i<$chs.length;i++){
                var v = $($chs[i]).val();
                if(v == "on") continue;
                siteIds.push(v);
            }
            deleteSites(siteIds.join());
        });
    });
</script>