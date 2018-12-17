using System;
using System.Web.UI;


namespace WebApplication1
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LevelControl1.AutomateName = "TestClient1";

            LevelControl1.ModuleName = "water";
            
        }
    }
}