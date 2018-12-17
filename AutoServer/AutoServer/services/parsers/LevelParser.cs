using AutoServer.DTO;
using AutoServer.Interfaces;
using System;
using System.Xml.Linq;

namespace AutoServer.services.parsers
{
    class LevelParser : ILocalParser
    {
        private ICacher<LevelData> _levelCacher;

        public LevelParser(ICacher<LevelData> levelCacher)
        {
            _levelCacher = levelCacher;
        }

        public bool Parse(XElement input, string clientLogin)
        {
            if (!(input.Attribute("moduleType").Value == "level"))
            {
                return false;
            }
            var level = input.Value;
            level = string.IsNullOrEmpty(level) ? "-1" : level.Replace('.', ',');
            var data = new LevelData
            {
                Name = clientLogin,
                ModuleName = input.Attribute("moduleName").Value.ToString(),
                Date = DateTime.Now,
                Level = Convert.ToDouble(level)
            };

            _levelCacher.Add(data);

            return true;
        }
    }
}
