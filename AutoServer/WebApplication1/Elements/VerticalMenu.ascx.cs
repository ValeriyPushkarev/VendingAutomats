using System;
using System.Web;

namespace WebApplication1.Elements
{
    public partial class WebUserControl1 : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Label1.Text =
                      "<ul id=\"menu\">"
                    + "   <li><a runat=\"server\" href=\"/Map\">Карта</a></li><br/>"
                    + "   <li><a runat=\"server\" href=\"/Priority\">Очередь</a></li><br/>"
                    + "   <li><a runat=\"server\" href=\"/Settings\">Настройки</a></li><br/>"
                    + "</ul>";
            }
            else
            {
                Label1.Text =
                  "<ul id=\"menu\">"
                + "   <li><a runat=\"server\" href=\"/\">Главная</a></li><br/>"
                + "   <li><a runat=\"server\" href=\"/Register\">Зарегистрироваться</a></li><br/>"
                + "</ul>";
            }
        }
    }
}