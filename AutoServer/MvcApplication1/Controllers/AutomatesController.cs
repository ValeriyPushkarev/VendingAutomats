using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApplication1.Services.DTO;
using WebApplication1.Services.Interfaces;
using WebApplication1.Services.Interfaces.Modules;

namespace MvcApplication1.Controllers
{
    public class AutomatesController : Controller
    {

        private IAutomateDataProvider _automateDataProvider;

        public AutomatesController(IAutomateDataProvider automateDataProvider)
        {
            _automateDataProvider = automateDataProvider;
        }

        public ActionResult Automates(string sorting = "sortByMin", string direction = "desc")
        {
            var automates = (from t in _automateDataProvider.GetAutomates()
                            select new
                            {
                                minLevel = (from mod in t.Modules
                                            where mod is ILevelModule
                                            orderby
                                            ((ILevelModule)mod).GetLatestLevelPercents().Value ascending
                                            select ((ILevelModule)mod).GetLatestLevelPercents().Value
                                                   ).FirstOrDefault()
                                       ,
                                maxLevel = (from mod in t.Modules
                                            where mod is ILevelModule
                                            orderby ((ILevelModule)mod).GetLatestLevelPercents().Value descending
                                            select ((ILevelModule)mod).GetLatestLevelPercents().Value
                                                   ).FirstOrDefault()
                                       ,
                                ping = (from mod in t.Modules
                                        where mod is IPingModule
                                        select ((IPingModule)mod).LastPing()).FirstOrDefault()
                                       ,
                                automate = t
                            }).ToList();

            var desc = direction == "desc";
            switch (sorting)
            {
                case "sortByMin":
                    if (desc)
                        ViewBag.automates = (from t in automates
                                             orderby t.minLevel descending
                                             select t.automate).ToList();
                    else
                        ViewBag.automates = (from t in automates
                                             orderby t.minLevel ascending
                                             select t.automate).ToList();
                    break;
                case "sortByMax":
                    if (desc)
                        ViewBag.automates = (from t in automates
                                             orderby t.maxLevel descending
                                             select t.automate).ToList();
                    else
                        ViewBag.automates = (from t in automates
                                             orderby t.maxLevel ascending
                                             select t.automate).ToList();
                    break;
                case "sortByPing":
                    if (desc)
                        ViewBag.automates = (from t in automates
                                             orderby t.ping descending
                                             select t.automate).ToList();
                    else
                        ViewBag.automates = (from t in automates
                                             orderby t.ping ascending
                                             select t.automate).ToList();
                    break;
            }

            return View();
        }


        public ActionResult Automate(string Name)
        {
            var automates = _automateDataProvider.GetAutomates();

            ViewBag.automate = automates.Where(t=>t.Name==Name).FirstOrDefault<IAutomate>();

            return View();
        }

        public ActionResult Params(string Name, string Address, string Desc)
        {
            var automate = _automateDataProvider.GetAutomate(Name);

            automate.Address = Address;

            automate.Desc = Desc;

            automate.Save();

            return Json(new { automate.Address, automate.Desc });
        }
    }
}
