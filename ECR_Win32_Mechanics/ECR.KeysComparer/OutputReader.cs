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
        /// �����������, ��������� ����� exe-����� �� �������� callback ������ � ����������� ����� ������
        /// </summary>
        /// <param name="process">��������� ������</param>
        public OutputReader(Process process)
        {
            _process = process;
        }

        /// <summary>
        /// Callback, �������� �� ������������ ������
        /// </summary>
        public void OutReader()
        {
            _standartOutput = _process.StandardOutput.ReadToEnd();
        }
        
        /// <summary>
        /// Callback �������� �� ������ ��� ������
        /// </summary>
        public void ErrorReader()
        {
            _errorOutput = _process.StandardError.ReadToEnd();
        }
        
        /// <summary>
        /// �������� ������������ ���������� �� ������������ ������
        /// </summary>
        public string StandartOutput
        {
            get { return _standartOutput; }
        }
        
        /// <summary>
        /// �������� ������������ ���������� �� ������ ��� ������
        /// </summary>
        public string ErrorOutput
        {
            get { return _errorOutput; }
        }

    }

}
