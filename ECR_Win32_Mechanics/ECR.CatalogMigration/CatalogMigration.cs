using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace ECR.CatalogMigration
{

    /// <summary>
    /// 
    /// </summary>
    class CatalogMigration
    {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
// ReSharper disable UnusedParameter.Local
        static void Main(string[] args)
// ReSharper restore UnusedParameter.Local
        {

            string _entityName;
            int _mappingType;

            Console.WriteLine("Начало миграции элементов...");
            
            var _packageSize = Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.PackageSize"));
            Console.WriteLine("Размер пакета: {0}", _packageSize);

            Console.WriteLine("Введите идентификатор сущности (1 - обложки (лицевая часть), 3 - аннотации):");
            var _s = Console.ReadLine();
            switch (_s)
            {
                case "1":
                    _entityName = "Books.Covers.Face";
                    _mappingType = 1;
                    break;
                case "3":
                    _entityName = "Books.Annots";
                    _mappingType = 3;
                    break;
                default:
                    Console.WriteLine("Неверно задан параметр маппирования сущностей.");
                    Console.ReadKey();
                    return;
            }

            Console.WriteLine("Введите номер начального пакета (по умолчанию 0):");
            var _beginFrom = Convert.ToInt32(Console.ReadLine());

            try
            {
                // Выполнение процедуры миграции
                Migrate(_mappingType, _entityName, _packageSize, _beginFrom, 0);
            }
            catch (Exception e)
            {
                Console.WriteLine("Ошибка выполнения процедуры миграции: " + e.Message);
            }

            Console.WriteLine("Для продолжения нажмите любую клавишу...");
            Console.ReadKey();

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="MappingType"></param>
        /// <param name="EntityName"></param>
        /// <param name="PackageSize"></param>
        /// <param name="BeginFrom"></param>
        /// <param name="PackagesCount"></param>
// ReSharper disable UnusedParameter.Local
        private static void Migrate(int MappingType, string EntityName, int PackageSize, int BeginFrom, int PackagesCount)
// ReSharper restore UnusedParameter.Local
        {
        
            // Проверяем параметры
            if(BeginFrom <0)
                throw new Exception("Неверно задана граница начальных данных.");
            if (PackagesCount < 0)
                throw new Exception("Неверно задано количество пакетов обработки данных.");
            
            // Определение расширения файла
            string _extension;
            switch (MappingType)
            {
                case 1:
                    _extension = ".jpg";
                    break;
                case 3:
                    _extension = ".txt";
                    break;
                default:
                    throw new Exception("Неверно задан параметр маппирования сущностей.");
            }

            // Вычисляем количество пакетов
            var _packagesCount = PackagesCount > 0
                                     ? PackagesCount
                                     : Convert.ToInt32(GetGoodImageCount(BeginFrom, MappingType) / PackageSize) + 1;
            // Вычисляем номер первого пакета
            var _package_number = (GetGoodImageCountLimit(0, BeginFrom, MappingType) / PackageSize);

            // Определяем Id начальной заливки
            var _beginFrom = BeginFrom;

            // Переменная определяет подсчет количества итераций для паузы
            var _pauseIterator = 0;

            for (var i = BeginFrom; i < _packagesCount; i++)
            {

                _package_number++;
                Console.WriteLine("Обрабатывается пакет: {0} из {1}...", _package_number, _packagesCount - BeginFrom);

                // Временная метка начала операции цикла
                var _dt_begin = DateTime.Now;

                // Инициализация/обнуление счетчиков
                var _processed = 0;
                var _success = 0;
                var _errors = 0;

                // Создаем и открываем соединение с базой данных
                var _conn = new SqlConnection(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.CatalogConnectionString"));
                _conn.Open();
                try
                {
                    var _cmd = new SqlCommand("[dbo].[cfm_GetGoodImageDataForMigration]", _conn)
                                   {CommandType = CommandType.StoredProcedure};
                    _cmd.Parameters.AddWithValue("@MappingType", MappingType);
                    _cmd.Parameters.AddWithValue("@PackageSize", PackageSize);
                    _cmd.Parameters.AddWithValue("@From", _beginFrom);

                    var _reader = _cmd.ExecuteReader();
                    if (_reader != null)
                    {

                        while (_reader.Read())
                        {

                            _processed++;
                            try
                            {

                                // Если файл уже есть в папке - удаляем
                                if (File.Exists(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.OutputDir") + _reader.GetString(1) + _extension))
                                    File.Delete(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.OutputDir") + _reader.GetString(1) + _extension);

                                if (_reader.GetSqlBinary(3).IsNull)
                                {

                                    var _o = new byte[0];
                                    using (var _stream = new FileStream(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.OutputDir") + _reader.GetString(1) + _extension, FileMode.Create, FileAccess.Write))
                                    {
                                        try
                                        {
                                            _stream.Write(_o, 0, 0);
                                            _success++;
                                        }
                                        finally
                                        {
                                            _stream.Close();
                                        }
                                    }

                                }
                                else
                                {
                                    // Запись файла на диск
                                    using (var _stream = new FileStream(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.OutputDir") + _reader.GetString(1) + _extension, FileMode.Create, FileAccess.Write))
                                    {
                                        try
                                        {
                                            _stream.Write(_reader.GetSqlBinary(3).Value, 0, (_reader.GetSqlBinary(3).Value).Length);
                                            _success++;
                                        }
                                        finally
                                        {
                                            _stream.Close();
                                        }
                                    }
                                }
                                // Переопределение значения переменной _beginFrom (важно!) идентификатором записи в базе
                                _beginFrom = _reader.GetInt32(0);

                            }
                            catch (Exception e)
                            {
                                Console.WriteLine("Ошибка операции выгрузки данных. Ключ позиции: '{0}', описание ошибки: '{1}'", _reader.GetString(1), e.Message);
                                _errors++;
                            }

                        }

                        var _sustract = DateTime.Now;

                        Console.WriteLine("Пакет: {0} из {1}. Обработано позиций: {2}, успешно: {3}, с ошибками: {4}.", _package_number, _packagesCount - BeginFrom, _processed, _success, _errors);
                        Console.WriteLine("Время обработки пакета: {0} мин. {1} сек.", _sustract.Subtract(_dt_begin).Minutes, (_sustract.Subtract(_dt_begin).Seconds - (_sustract.Subtract(_dt_begin).Minutes)*60));

                        _pauseIterator++;
                        if (_pauseIterator == Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.PauseIteratorInterval")))
                        {
                            Console.WriteLine();
                            Console.WriteLine("Хотите обработать следующую партию пакетов? Для продолжения нажмите Y, для отмены - любую другую клавишу.");
                            var _key = Console.ReadKey();
                            if ((_key.KeyChar != ("Y".ToCharArray()[0])) && (_key.KeyChar != ("y".ToCharArray()[0])))
                            {
                                Console.WriteLine();
                                Console.WriteLine("Операция обработки прервана клиентом");
                                return;
                            }
                            _pauseIterator = 0;
                            Console.WriteLine();
                        }
                        Console.WriteLine();
                    
                    }

                }
                catch(Exception e)
                {
                    Console.WriteLine("Ошибка обработки данных: {0}. Операция обработки данных прервана.", e.Message);
                }
                finally
                {
                    _conn.Close();
                }

            }


        }

        /// <summary>
        /// Процедура возвращает количество записей заданного типа, содержащихся в базе данных Catalog
        ///     и удовлетворяющих условию: 'Id > From'
        /// </summary>
        /// <param name="From">Значение начальной границы</param>
        /// <param name="MappingType">Тип маппирования (1 - обложки, 3 - аннотации)</param>
        /// <returns>Количество записей в базе данных, соответствующих заданным условиям</returns>
        private static int GetGoodImageCount(int From, int MappingType)
        {
            var _conn = new SqlConnection(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.CatalogConnectionString"));
            _conn.Open();
            try
            {
                var _cmd = new SqlCommand("[dbo].[cfm_GetGoodImageCountForMigration]", _conn)
                               {CommandType = CommandType.StoredProcedure};
                _cmd.Parameters.AddWithValue("@MappingType", MappingType);
                _cmd.Parameters.AddWithValue("@From", From);
                return (int)_cmd.ExecuteScalar();
            }
            finally
            {
                _conn.Close();
            }
        }

        /// <summary>
        /// Процедура возвращает количество записей заданноего типа, 
        ///     содержащихся в базе данных Catalog и удовлетворяющих условиям: Id > From, To > Id
        /// </summary>
        /// <param name="From">Значение начальной границы</param>
        /// <param name="To">Значение конечной границы</param>
        /// <param name="MappingType">Тип маппирования (1 - обложки, 3 - аннотации)</param>
        /// <returns>Количество записей в базе данных, соответствующих заданным условиям</returns>
        private static int GetGoodImageCountLimit(int From, int To, int MappingType)
        {
            var _conn = new SqlConnection(ConfigurationManager.AppSettings.Get("ECR.CatalogMigration.CatalogConnectionString"));
            _conn.Open();
            try
            {
                var _cmd = new SqlCommand("[dbo].[cfm_GetGoodImageCountLimitedForMigration]", _conn)
                               {CommandType = CommandType.StoredProcedure};
                _cmd.Parameters.AddWithValue("@MappingType", MappingType);
                _cmd.Parameters.AddWithValue("@From", From);
                _cmd.Parameters.AddWithValue("@To", To);
                return (int)_cmd.ExecuteScalar();
            }
            finally
            {
                _conn.Close();
            }
        }

    }

}
