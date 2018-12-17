using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApplication1.Services.Interfaces.Modules
{
    public interface ILevelModule : IModule
    {
        double MaxLevel { get; set; }

        double MinLevel { get; set; }

        double AlertLevel1 { get; set; }

        bool AlertLevel1Enabled { get; set; }

        double AlertLevel2 { get; set; }

        bool AlertLevel2Enabled { get; set; }

        double GetLevelPercent();

        Dictionary<DateTime, double> GetLevelsFromInterval(DateTime from, DateTime to, int Definition);
    }
}
