using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace IOExtensions
{
    /// <summary>
    /// 
    /// </summary>
    internal class OutputReader
    {
        
        private Process _process;
        private string _standartOutput;
        private string _errorOutput;

        /// <summary>
        ///  онструктор, принимает хэндл exe-шника из которого callback методы в последствии будут читать
        /// </summary>
        /// <param name="process">Ёкземпл€р хэндла</param>
        public OutputReader(Process process)
        {
            _process = process;
        }

        /// <summary>
        /// Callback, читающий из стандартного вывода
        /// </summary>
        public void OutReader()
        {
            _standartOutput = _process.StandardOutput.ReadToEnd();
        }
        
        /// <summary>
        /// Callback читающий из вывода дл€ ошибок
        /// </summary>
        public void ErrorReader()
        {
            _errorOutput = _process.StandardError.ReadToEnd();
        }
        
        /// <summary>
        /// —войство возвращающее полученное из стандартного вывода
        /// </summary>
        public string StandartOutput
        {
            get { return _standartOutput; }
        }
        
        /// <summary>
        /// —войство возвращающее полученное из вывода дл€ ошибок
        /// </summary>
        public string ErrorOutput
        {
            get { return _errorOutput; }
        }

    }

}
