// *********************************************************************************************************************************
//
// mmx, 2009
// Сервис сопоставления наименований файлов по заданным ключам (определениям) в названиях.
// Переименовывает файлы в соответствии с заданными условиями и скаладывает их в заданную папку;
//
// *********************************************************************************************************************************

using System;
using System.Reflection;
using System.Configuration;
using System.Diagnostics;
using System.IO;

using log4net;
using log4net.Config;
using log4net.MDCReflector;

using ConfigurationExtensions;

namespace ECR.KeysComparer
{

    /// <summary>
    /// Оберточный класс, реализующий функциональность класса CompareAgent в консоли
    /// </summary>
    public class KeysComparer
    {

        private static bool INTERACTIVE;

        private static readonly Assembly _assembly = Assembly.GetExecutingAssembly();
        private static readonly ExeConfigurationFileMap _filemap = new ExeConfigurationFileMap();

        #region Logging objects and variables

        private static bool DEBUG;
        private readonly static ILog _log = LogManager.GetLogger(_assembly.GetName().Name);
        private readonly static ILog _log_notifications = LogManager.GetLogger(_assembly.GetName().Name + ".NotificationsLogger");
#pragma warning disable 169
        private readonly static MDCReflector _reflector = new MDCReflector();
#pragma warning restore 169

        #endregion
        
        /// <summary>
        /// Главная процедура запуска консоли приложения
        /// </summary>
        /// <param name="p_args">Массив аргументов командной строки</param>
        public static void Main(string[] p_args)
        {

            try
            {
                // Определяем интерактивный режим: может ли приложение взаимодействовать с рабочим столом пользователя;
                // Необходимо для уменьшения количества сообщений, выводимых в консоль при запуске из-под агентов;
                INTERACTIVE = IsApplicationInteractive();
                // Настройка параметров вывода в консоль
                ConfigureConsoleOutput();
                // Вывод информации о приложении
                PrintAssemblyInfo();
            }
            catch (Exception e)
            {
                if (INTERACTIVE)
                    Console.WriteLine(e.ToString());
                return;
            }

            // Конфигурирование подсистемы логгирования (log4net)
            if (!ConfigureLoggingSubsystem())
                return;

            // Для режима отладки: дополнительная возможность ввести аргументы командной строки приложения
            if (INTERACTIVE)
            {
                Console.WriteLine("[Logging subsystem initialized]");
                if (_assembly.FullName != null) Console.WriteLine(_assembly.FullName);
            }

            // Если нет аргументов, то отображаем справочную информацию и выходим
            if (p_args.Length == 0)
            {
                Execute(p_args);
                PrintFooter();
                return;
            }

            if (INTERACTIVE)
                Console.Write(Environment.NewLine);

            // Разбор введенных аргументов командной строки
            switch (p_args[0].ToLower().Replace("/", ""))
            {
                case "help":                    // Справочная информация
                    PrintUsageStatement();
                    break;
                case "exec":
                    Execute(p_args);
                    break;
                default:
                    _log.Error(string.Format("Неизвестный формат командной строки: '{0}'", p_args.ToString()));
                    Console.WriteLine("Неизвестный формат командной строки. Используйте команду '/help' для просмотра доступных команд.");
                    break;
            }

            PrintFooter();

        }

        /// <summary>
        /// Функция запускает основную процедуру приложения
        /// </summary>
        private static void Execute(string[] p_args)
        {
            var _assemblyName = _assembly.GetName().Name;
            _log.Info("Process started");
            _log_notifications.Info(string.Format("Start notification created for process: {0}", _assemblyName));
            try
            {
                var _filepath = p_args.Length > 1 ? p_args[1] : _assembly.Location + ".config";
                if (!File.Exists(_filepath))
                    throw new Exception(string.Format("Отсутствует конфигурационный файл приложения или доступ запрещен: '{0}'", _filepath));

                _filemap.ExeConfigFilename = _filepath;
                var _configuration = ConfigurationManager.OpenMappedExeConfiguration(_filemap, ConfigurationUserLevel.None);
                var _extender = new KeyValueConfigurationCollectionExtender(_configuration.AppSettings.Settings);

                DEBUG = Convert.ToBoolean(_extender.GetValue(string.Format("{0}.ApplicationDebugMode", _assemblyName), "false"));
                PrintDebugHeader();

                var _agent = new CompareAgent(DEBUG);
                _agent.Execute();

                _log.Info("Completed");
            }
            catch (Exception e)
            {
                _log.Fatal("Fatal error", e);
                _log_notifications.Fatal(string.Format("Error notification created for process: {0}", _assemblyName), e);
            }
            finally
            {
                _log_notifications.Info(string.Format("End notification created for process: {0}", _assemblyName));
            }
        }

        /// <summary>
        /// Функция определяет, может ли приложение взаимодействовать с рабочим столом (есть ли главное окно приложения)
        /// </summary>
        /// <returns></returns>
        private static bool IsApplicationInteractive()
        {
            return (Process.GetCurrentProcess().MainWindowHandle.ToInt64() > 0);
        }

        /// <summary>
        /// Настройка параметров вывода в консоль
        /// </summary>
        private static void ConfigureConsoleOutput()
        {
            if (!INTERACTIVE) return;
            //Console.SetWindowSize(128, 64);
            Console.ResetColor();
        }
        
        /// <summary>
        /// Конфигурирование подсистемы логгирования (log4net) 
        /// </summary>
        /// <returns></returns>
        private static bool ConfigureLoggingSubsystem()
        {
            var _result = true;
            try
            {
#pragma warning disable 612,618
                DOMConfigurator.Configure();
#pragma warning restore 612,618
            }
            catch (Exception e)
            {
                _result = false;
                if (INTERACTIVE)
                    Console.WriteLine(e.ToString());
                PrintFooter();
            }
            return _result;
        }

        /// <summary>
        /// Вывод информации о включении отладочного режима в приложении
        /// </summary>
        private static void PrintDebugHeader()
        {
            if (INTERACTIVE)
                Console.WriteLine("[Application debug mode enabled]");
        }

        /// <summary>
        /// Остановка приложения с ожиданием нажатия любой клавиши в отладочном режиме
        /// </summary>
        private static void PrintFooter()
        {
            if (!INTERACTIVE) return;
            Console.Write(Environment.NewLine);
            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }

        /// <summary>
        /// Процедура выводит информацию о приложении/сборке в консоль
        /// </summary>
        private static void PrintAssemblyInfo()
        {
            if (!INTERACTIVE) return;
            Console.WriteLine("[{0}]", GetAssemblyInfo());
        }

        /// <summary>
        /// Функция возвращает краткую информацию о наименовании и версии сборки
        /// </summary>
        /// <returns></returns>
        private static string GetAssemblyInfo()
        {
            var _version = _assembly.GetName().Version;
            return string.Format("{0}, version {1}.{2}.{3}.{4}", _assembly.GetName().Name, _version.Major, _version.Minor, _version.Build, _version.Revision);
        }

        /// <summary>
        /// Процедура выводит в консоль справочную информацию о доступных командах консоли приложения
        /// </summary>
        private static void PrintUsageStatement()
        {
            Console.WriteLine("Usage command syntax:");
            Console.WriteLine("{0, -18}", "/help");
            Console.WriteLine("{0, -18}", "     Displays available application help information");
            Console.WriteLine("{0, -18}", "<no parameters>, /exec [<filepath>]");
            Console.WriteLine("{0, -18}", "     Starts with settings defined in <filepath> application configuration file");
            Console.WriteLine("{0, -18}", "     [<filepath>] is an optional parameter that defines application configuration file from specified file path, App.config file using by default");
        }

    }

}
