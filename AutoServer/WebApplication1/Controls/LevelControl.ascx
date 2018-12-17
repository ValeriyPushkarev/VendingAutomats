<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LevelControl.ascx.cs" Inherits="WebApplication1.Controls.LevelControl" %>

<script src="Scripts/jquery/external/jquery/jquery.js"></script>
<script src="Scripts/jquery/jquery-ui.js"></script>
<script src="Scripts/clockpicker/jquery-clockpicker.js"></script>
<link rel="stylesheet" href="Scripts/clockpicker/jquery-clockpicker.css">
<link rel="stylesheet" href="Scripts/jquery/jquery-ui.css">
<script>
    $(function () {
        $(".datepicker").datepicker(
            { dateFormat: "dd/mm/yy" },
            $.datepicker.regional['ru']
            );
    });
</script>
<div style="width: 450px; height: 220px">
    <div style="width: 310px; height: 260px; float: left">
        <asp:Chart ID="Chart1" runat="server" Height="250px" Width="300px" Style="margin-bottom: 0px">
            <Series>
                <asp:Series ChartType="Point" Name="Series1" XValueType="DateTime" XValueMember="Key" YValueMembers="Value"
                    YValueType="Auto">
                </asp:Series>
            </Series>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1">
                    <AxisX IntervalAutoMode="VariableCount" LabelAutoFitStyle="IncreaseFont, DecreaseFont, StaggeredLabels, LabelsAngleStep90, WordWrap" MaximumAutoSize="85">
                        <LabelStyle Angle="90" Format="dd.MM.yy HH:mm" Interval="Auto" />
                    </AxisX>
                </asp:ChartArea>
            </ChartAreas>
        </asp:Chart>

    </div>
    <div style="float: left; width: 110px">
        C
    <div style="float: left">
        <asp:TextBox ID="DateFrom" Style="width: 100px" CssClass="datepicker" runat="server" OnTextChanged="DateFrom_TextChanged">9/23/2009</asp:TextBox>
    </div>
        <div style="float: left" class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
            <asp:TextBox ID="TimeFrom" Style="width: 100px" CssClass="form-control" runat="server" OnTextChanged="TimeFrom_TextChanged">13:14</asp:TextBox>
            <span class="input-group-addon">
                <span class="glyphicon glyphicon-time"></span>
            </span>
        </div>
        <script type="text/javascript">
            $('.clockpicker').clockpicker({
                placement: 'bottom',
                align: 'left',
                donetext: 'Done'
            });
        </script>
    </div>
    <div style="float: left; width: 110px">
        По
    <div style="float: left">
        <asp:TextBox ID="DateTo" Style="width: 100px" CssClass="datepicker" runat="server" OnTextChanged="DateTo_TextChanged">9/23/2009</asp:TextBox>
    </div>
        <div style="float: left" class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
            <asp:TextBox ID="TimeTo" Style="width: 100px" CssClass="form-control" runat="server" OnTextChanged="TimeTo_TextChanged">13:14</asp:TextBox>
            <span class="input-group-addon">
                <span class="glyphicon glyphicon-time"></span>
            </span>
        </div>

        <script type="text/javascript">
            $('.clockpicker').clockpicker({
                placement: 'bottom',
                align: 'left',
                donetext: 'Done'
            });
        </script>
        <div style="float: left">
            <asp:Button ID="Button1" runat="server" Text="Обновить" Width="100px" />
            <br />
        </div>
        <div style="float: left">
            <asp:Button ID="Button2" runat="server" Text="Настройки" Width="100px" />
            <br />
        </div>
    </div>
</div>
