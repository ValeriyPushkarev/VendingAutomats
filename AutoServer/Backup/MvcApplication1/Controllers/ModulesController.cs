using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApplication1.Services.Interfaces.Modules;

namespace MvcApplication1.Controllers
{
    public class ModulesController : Controller
    {

        private ILevelModule _levelModule;

        public ModulesController(ILevelModule levelModule)
        {
            _levelModule = levelModule;
        }


        public ActionResult Level()
        {
            var ClientId = 2;
            var Name = "water";

            ViewBag.ClientId = ClientId;
            ViewBag.Name = Name;

            _levelModule.Initialize(ClientId, Name);

            ViewBag.MaxLevel = _levelModule.MaxLevel;
            ViewBag.MinLevel = _levelModule.MinLevel;

            return View();
        }

        public ActionResult Levels(int ClientId, string ModuleName, DateTime DateFrom, DateTime DateTo, TimeSpan TimeFrom, TimeSpan TimeTo)
        {
            _levelModule.Initialize(ClientId, ModuleName);

            var max = _levelModule.MaxLevel;
            var min = _levelModule.MinLevel;

            var z = _levelModule.GetLevelsFromInterval(DateFrom.Add(TimeFrom), DateTo.Add(TimeTo), 20)
                .OrderBy(t => t.Key)
                .Select(t => new { Date = t.Key.ToString("dd.MM.yyyy hh:mm"), Value = (min - t.Value -max)*100/(min-max) });

            var res = Json(z, JsonRequestBehavior.AllowGet);

            return res;
        }

        public ActionResult Params(int ClientId, string ModuleName, double MinLevel, double MaxLevel)
        {
            _levelModule.Initialize(ClientId, ModuleName);

            _levelModule.MaxLevel = MaxLevel;

            _levelModule.MinLevel = MinLevel;

            _levelModule.Save();

            return Json(new { _levelModule.MinLevel, _levelModule.MaxLevel });
        }
    }
}
