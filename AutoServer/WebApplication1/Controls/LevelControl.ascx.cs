using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using WebApplication1.Services.Interfaces;
using WebApplication1.Services.Interfaces.Modules;
using Unity.Web;
using System.Globalization;

namespace WebApplication1.Controls
{
    public partial class LevelControl : System.Web.UI.UserControl
    {
        private DateTime _from;
        private DateTime _to;

        private IUnityContainer _container;

        private string _automateName;

        private ILevelModule _module;

        public string AutomateName
        {
            get { return _automateName; }
            set { _automateName = value; }
        }

        private string _moduleName = "";

        public string ModuleName
        {
            get { return _moduleName; }
            set { _moduleName = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _container = Application.Contents.GetContainer();
            var automateProv = _container.Resolve<IAutomateDataProvider>();

            var automate = automateProv.GetAutomate(_automateName);
            if (IsPostBack != true)
            {
                _to = DateTime.Now;
                DateTo.Text = _to.Date.ToString("dd'/'MM'/'yyyy");
                TimeTo.Text = _to.ToString("HH\\:mm");
                _from = (DateTime.Now).AddDays(-1);
                DateFrom.Text = _from.Date.ToString("dd'/'MM'/'yyyy");
                TimeFrom.Text = _from.ToString("HH\\:mm");
            }
            else
            {
                ChangeDateFrom();
                ChangeDateTo();
            }

            _module = (ILevelModule)automate.Modules.First(t => t.Name == _moduleName && t.Type == Services.DTO.ModuleType.Level);

            RefreshDiagram();
        }

        protected void RefreshDiagram()
        {
            if (_module == null)
            {
                var automateProv = _container.Resolve<IAutomateDataProvider>();

                var automate = automateProv.GetAutomate(_automateName);
                _module = (ILevelModule)automate.Modules.First(t => t.Name == _moduleName && t.Type == Services.DTO.ModuleType.Level);
            }
           var data = _module.GetLevelsFromInterval(_from, _to, 100);

           Chart1.ChartAreas["ChartArea1"].AxisX.Minimum = _from.ToOADate();
           Chart1.ChartAreas["ChartArea1"].AxisX.Maximum = _to.ToOADate();

            foreach (KeyValuePair<DateTime, double> dat in data)
                Chart1.Series[0].Points.AddXY(dat.Key, dat.Value);
        }

        protected DateTime ParseDate(string s)
        {
            return DateTime.ParseExact(s,
              new[] { "dd/MM/yyyy", "d/MM/yyyy", "DD/MM/yyyy" },
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None);
        }

        protected TimeSpan ParseTime(string s)
        {
            return TimeSpan.ParseExact(s,
                new[] { "hh\\:mm" }, CultureInfo.InvariantCulture, TimeSpanStyles.None);
        }

        protected void ChangeDateFrom()
        {
            var date = ParseDate(DateFrom.Text);
            var time = ParseTime(TimeFrom.Text);
            _from = date.Add(time);
        }

        protected void ChangeDateTo()
        {
            var date = ParseDate(DateTo.Text);
            var time = ParseTime(TimeTo.Text);
            _to = date.Add(time);
        }

        private void ChangeDate()
        {
            ChangeDateFrom();
            ChangeDateTo();
            RefreshDiagram();
        }

        protected void DateFrom_TextChanged(object sender, EventArgs e)
        {
            ChangeDate();
        }

        protected void TimeFrom_TextChanged(object sender, EventArgs e)
        {
            ChangeDate();
        }

        protected void DateTo_TextChanged(object sender, EventArgs e)
        {
            ChangeDate();
        }

        protected void TimeTo_TextChanged(object sender, EventArgs e)
        {
            ChangeDate(); 
        }
    }
}