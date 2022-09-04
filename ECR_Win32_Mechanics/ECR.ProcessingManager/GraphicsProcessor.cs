using System;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using Atalasoft.ImgX6Interop;
using ImgX = Atalasoft.ImgX6Net.ImgX; 

namespace ECR.ProcessingManager
{

    /// <summary>
    /// Класс процессинга графических объектов ECR
    /// </summary>
    public class GraphicsProcessor : IECRProcessor
    {

        // TODO: begin hardcode
        // Константы должны переходить из конфигуратора, подтягиваясь в конструкторе по свойству ContainerId
        private const int _contrast = 10;
        private const int _brithness = 0;
        private const bool _ignoreAlpha = true;
        private const double _saturationLevel = 1.15;
        private const int _treshold = 0;
        private const double _amount = 0.5;
        private const double _sigma = 1;
        private const int _bitsPerPixel = 32;
        private const ImgX_ResizeMethods _resizeMethod = ImgX_ResizeMethods.ixrmCatromFilter;
        // end hardcode

        /// <summary>
        /// Идентификатор контейнера для определения преобразований
        /// </summary>
        public int ContainerId { get; set; }

        private static readonly ImgX imgX = new ImgX();
        private static ImgX_MemoryFileTypes imageType;

        /// <summary>
        /// GraphicsProcessor class constructor
        /// </summary>
        /// <param name="ContainerId">Идентификатор контейнера для определения преобразований</param>
        public GraphicsProcessor(int ContainerId)
        {
            // Licensing ImgX
            imgX.Register(ConfigurationManager.AppSettings.Get("ImgX.Register.UserName"),
                          ConfigurationManager.AppSettings.Get("ImgX.Register.RegCode"));
            imgX.RegisterLZW(ConfigurationManager.AppSettings.Get("ImgX.LZW_Unlock_Code"));
            // imgX.JPGQuality = 100;          // maximum JPG quality by default
            // imgX.JPEGQuality default JPGQuality parameter value
            imgX.JPGQuality = Convert.ToInt32(ConfigurationManager.AppSettings.Get("ImgX.JpegQuality"));
            // Container initialization
            this.ContainerId = ContainerId;
            LoadContainerProperties(ContainerId);
        }
        
        #region Public class members

        /// <summary>
        /// Процедура инициализации свой контейнера для определения преобразований
        /// </summary>
        /// <param name="ContainerId">Идентификатор контейнера для определения преобразований</param>
// ReSharper disable ParameterHidesMember
        public void LoadContainerProperties(int ContainerId)
// ReSharper restore ParameterHidesMember
        {
            // TODO: container properties initialization here!
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, ref string err)
        {
            string[] _params = {};
            return LoadObject(o, CheckProperties, ProcessingDefault, _params, ref err);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string Params, ref string err)
        {
            if (Params != null)
                return LoadObject(o, CheckProperties, ProcessingDefault, Params.Split((char)44), ref err);
            string[] _params = { };
            return LoadObject(o, CheckProperties, ProcessingDefault, _params, ref err);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string[] Params, ref string err)
        {
            err = null;

            // Проверка наличия параметров
            if (Params.Length == 0)
                throw new Exception("Не заданы параметры обработки данных");
            // Проверка данных
            if (o == null)
            {
                err = "Не заданы данные для загрузки изображения";
                return false;
            }

            // Загрузка массива байт, соответствующего изображению, из передаваемого объекта
            var _o = (byte[]) o;

            // Загрузка изображения в объект ImgX
            LoadImage(_o, GetImgXMemoryFileType(Params[0]));
            // Пересохраняем изображение через объект ImgX с необходимыми параметрами.
            // ВАЖНО: без этой операции некоторые типы изображений проверяются/обрабатываются некорректно
            //  (search error: GDI+ General error occured, Indexed image types)
            _o = ExportImage(GetImgXMemoryFileType(Params[0]));

            // Проверка свойств изображения заданным условиям
            if (CheckProperties)
            {
                if (!PropertiesCheck(_o, Params, ref err))
                    return false;
            }

            // Загрузка изображения в объект ImgX
            LoadImage(_o, GetImgXMemoryFileType(Params[0]));

            // Применение преобразований "по умолчанию"
            if(ProcessingDefault)
                DefaultProcessing();

            return true;
        }

        /// <summary>
        /// Преобразование оригинального представления
        /// </summary>
        /// <returns></returns>
        public byte[] GetBase()
        {
            // Экспорт изображения в буфер из коллекции Images объекта ImgX
            var _buffer = new byte[imgX.Images[0].MemoryUse];
            imgX.Export.ToMemoryFile(ref _buffer, imageType, _bitsPerPixel, false);
            return _buffer;
        }

        /// <summary>
        /// Процедура производит преобразования "по умолчанию"
        /// </summary>
        private static void DefaultProcessing()
        {
            // Применение фильтров
            imgX.Filters.Contrast(_contrast, _brithness, _ignoreAlpha, string.Empty);
            imgX.Filters.Saturation(_saturationLevel, string.Empty);
            imgX.Filters.UnsharpMask(_treshold, _amount, _sigma, string.Empty);
            //imgX.Filters.Blur(10, 3,_ignoreAlpha, string.Empty);
            // Очистка тэгов EXIF изображения
            EXIFClear();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        public byte[] CreateView(string ItemType, string Params)
        {
            // Разбиваем строку параметров
            var _params = Params.Split((char)44);
            return CreateView(ItemType, _params);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        public byte[] CreateView(string ItemType, string[] Params)
        {
            return CreateImageView(GetImgXMemoryFileType(
                Params[0]),
                Convert.ToInt32(Params[1]),
                Convert.ToInt32(Params[2]),
                ConfigurationManager.AppSettings.Get("ECR.ProcessingManager.PathDebug")
                );
        }

        /// <summary>
        /// Проверка свойств объекта согласно свойствам, заданным в контейнере
        /// </summary>
        /// <param name="o">Массив байт, соответствующий изображению</param>
        /// <param name="Params">Строка передачи параметров</param>
        /// <param name="err">Возвращаемое описание ошибки</param>
        /// <returns>true если проверка прошла успешно, false - в противном случае</returns>
        private bool PropertiesCheck(byte[] o, string[] Params, ref string err)
        {
            
            err = null;

            // Проверка формата изображения (ImageFormat)
            if (!ImageFormatEquals(GetImageFormat(o), GetImageRawFormat(Params[0])))
            {
                err = string.Format("Формат изображения не соответствует заданному. Определяемый формат: {0}", Params[0]);
                return false;
            }

            // Проверка цветности (PixelFormat)
            var _pf = GetImagePixelFormat(o);
            if (_pf != PixelFormat.Format24bppRgb)
            {
                err = "Неразрешенный формат цветности изображения: " + _pf;
                return false;
            }
            
            // Проверка минимального значения ширины изображения
            if (imgX.Images[0].Width < Convert.ToInt32(Params[1]))
            {
                err = string.Format("Недопустимый размер изображения: {0}", imgX.Images[0].Width);
                return false;
            }

            return true;
        }

        #endregion

        #region Private class members

        /// <summary>
        /// Очистка буфера изображений
        /// </summary>
        private static void Clear()
        {
            imgX.Images.Clear(string.Empty);
        }

        // ****************************************************************************************************

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ImageType"></param>
        /// <param name="Width"></param>
        /// <param name="Quality"></param>
        /// <param name="DebugPath"></param>
        /// <returns></returns>
        private byte[] CreateImageView(ImgX_MemoryFileTypes ImageType, int Width, int Quality, string DebugPath)
        {
            // Сохраняем оригинальное изображение в буферной переменной
            var __buffer = GetBase();

            // Для представлений изображение преобразуется с заданным JPGQuality
            //  из элемента массива Params[2] объекта ecr.View соответствующей сущности таблицы ecr.Views
            imgX.JPGQuality = Quality;
            
            // Проверка ширины изображения
            if (imgX.Images[0].Width > Width)
            {
                // Производим преобразования (resize)
                var _resizeCoef = Width/Convert.ToDouble(imgX.Images[0].Width);
                imgX.Effects.Resize(Width, (int) (imgX.Images[0].Height*_resizeCoef), _resizeMethod, string.Empty);
            }
            else
            {
                // TODO: сделать подложку (опционально по дополнительному параметру из строки Params)
            }
            
            // Экспорт изображения в режиме DEBUG
            if (DebugPath.Length > 0)
            {
                var r = new Random((int)(DateTime.Now.Ticks));
                ExportImage(DebugPath + r.Next() + "." + GetImgXFileExt(ImageType), ImageType);
            }

            // Выгружаем полученные данные в переменную _buffer
            var _buffer = ExportImage(ImageType);
            // Загружаем буферную переменную обратно
            LoadImage(__buffer, imageType);

            // Возвращаем значение JPGQuality равным заданным по умолчанию
            //imgX.JPGQuality = 100;
            imgX.JPGQuality = Convert.ToInt32(ConfigurationManager.AppSettings.Get("ImgX.JpegQuality"));

            return _buffer;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="ImageType"></param>
        private static void LoadImage(byte[] o, ImgX_MemoryFileTypes ImageType)
        {
            // Очищаем базовый буфер и загружаем буферную переменную обратно
            Clear();
            // Возвращаем преобразованное изображение обратно
            imgX.Import.FromMemoryFile(ref o, ImageType, string.Empty);
            // Запоминаем тип изображения в объкт типа ImageType
            imageType = ImageType;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ImageType"></param>
        /// <returns></returns>
        private static byte[] ExportImage(ImgX_MemoryFileTypes ImageType)
        {
            // Выгружаем данные изображения в переменную _buffer
            var _buffer = new byte[imgX.Images[0].MemoryUse];
            imgX.Export.ToMemoryFile(ref _buffer, ImageType, _bitsPerPixel, false);
            return _buffer;
        }

        ///<summary>
        ///</summary>
        ///<param name="ImagePath"></param>
        ///<param name="ImageType"></param>
        private static void ExportImage(string ImagePath, ImgX_MemoryFileTypes ImageType)
        {
            imgX.Export.ToFile(ImagePath, GetImgXFileSaveType(ImageType), _bitsPerPixel, false);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        private static ImageFormat GetImageFormat(byte[] o)
        {
            // Загружаем данные об изображении через MemoryStream
            using (var _stream = new MemoryStream(o))
            {
                // Получаем объект ImageFormat для потока изображения
                var _img = Image.FromStream(_stream);
                return _img.RawFormat;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        private static PixelFormat GetImagePixelFormat(byte[] o)
        {
            // Загружаем данные об изображении через MemoryStream
            using (var _stream = new MemoryStream(o))
            {
                // Получаем объект ImageFormat для потока изображения
                var _img = Image.FromStream(_stream);
                return _img.PixelFormat;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Source"></param>
        /// <param name="Target"></param>
        /// <returns></returns>
        private static bool ImageFormatEquals(ImageFormat Source, ImageFormat Target)
        {
            return Source.Guid == Target.Guid;
        }

        /// <summary>
        /// 
        /// </summary>
        private static void EXIFClear()
        {
            var exif = imgX.Images[0].get_EXIF();
            exif.Clear();
            imgX.Images[0].set_EXIF(ref exif);
        }

        #endregion

        #region Non-interfaced classs public members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Format"></param>
        /// <returns></returns>
        private ImgX_MemoryFileTypes GetImgXMemoryFileType(string Format)
        {
            var _format = GetImageRawFormat(Format);
            return GetImgXMemoryFileType(_format);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Format"></param>
        /// <returns></returns>
        private ImgX_MemoryFileTypes GetImgXMemoryFileType(ImageFormat Format)
        {
            if (Format.Guid == ImageFormat.Bmp.Guid)
                return ImgX_MemoryFileTypes.ixmfBMP;
            if (Format.Guid == ImageFormat.Gif.Guid)
                return ImgX_MemoryFileTypes.ixmfGIF;
            if (Format.Guid == ImageFormat.Jpeg.Guid)
                return ImgX_MemoryFileTypes.ixmfJPG;
            if (Format.Guid == ImageFormat.MemoryBmp.Guid)
                return ImgX_MemoryFileTypes.ixmfBMP;
            if (Format.Guid == ImageFormat.Png.Guid)
                return ImgX_MemoryFileTypes.ixmfPNG;
            if (Format.Guid == ImageFormat.Tiff.Guid)
                return ImgX_MemoryFileTypes.ixmfTIF;
            // Unsupported imaged types: Icon, mf, Exif, Wmf
            throw new Exception(string.Format("Unsopported image format: {0}", GetImageRawFormat(Format)));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ImageType"></param>
        /// <returns></returns>
        private static ImgX_FileSaveTypes GetImgXFileSaveType(ImgX_MemoryFileTypes ImageType)
        {
            if (ImageType == ImgX_MemoryFileTypes.ixmfBMP)
                return ImgX_FileSaveTypes.ixfsBMP;
            if (ImageType == ImgX_MemoryFileTypes.ixmfGIF)
                return ImgX_FileSaveTypes.ixfsGIF;
            if (ImageType == ImgX_MemoryFileTypes.ixmfJPG)
                return ImgX_FileSaveTypes.ixfsJPG;
            if (ImageType == ImgX_MemoryFileTypes.ixmfPCX)
                return ImgX_FileSaveTypes.ixfsPCX;
            if (ImageType == ImgX_MemoryFileTypes.ixmfPNG)
                return ImgX_FileSaveTypes.ixfsPNG;
            if (ImageType == ImgX_MemoryFileTypes.ixmfPSD)
                return ImgX_FileSaveTypes.ixfsPSD;
            if (ImageType == ImgX_MemoryFileTypes.ixmfTGA)
                return ImgX_FileSaveTypes.ixfsTGA;
            if (ImageType == ImgX_MemoryFileTypes.ixmfTIF)
                return ImgX_FileSaveTypes.ixfsTIF;
            if (ImageType == ImgX_MemoryFileTypes.ixmfTLA)
                return ImgX_FileSaveTypes.ixfsTLA;
            if (ImageType == ImgX_MemoryFileTypes.ixmfWBMP)
                return ImgX_FileSaveTypes.ixfsWBMP;
            // Unsupported imaged types: Icon, mf, Exif, Wmf
            throw new Exception(string.Format("Unsopported image type: {0}", ImageType));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ImageType"></param>
        /// <returns></returns>
        private static string GetImgXFileExt(ImgX_MemoryFileTypes ImageType)
        {
            if (ImageType == ImgX_MemoryFileTypes.ixmfBMP)
                return "bmp";
            if (ImageType == ImgX_MemoryFileTypes.ixmfGIF)
                return "gif";
            if (ImageType == ImgX_MemoryFileTypes.ixmfJPG)
                return "jpg";
            if (ImageType == ImgX_MemoryFileTypes.ixmfPCX)
                return "pcx";
            if (ImageType == ImgX_MemoryFileTypes.ixmfPNG)
                return "png";
            if (ImageType == ImgX_MemoryFileTypes.ixmfPSD)
                return "psd";
            if (ImageType == ImgX_MemoryFileTypes.ixmfTGA)
                return "tga";
            if (ImageType == ImgX_MemoryFileTypes.ixmfTIF)
                return "tiff";
            if (ImageType == ImgX_MemoryFileTypes.ixmfTLA)
                return "tla";
            if (ImageType == ImgX_MemoryFileTypes.ixmfWBMP)
                return "wbmp";
            // Unsupported imaged types: Icon, mf, Exif, Wmf
            throw new Exception(string.Format("Unsopported image type: {0}", ImageType));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Format"></param>
        /// <returns></returns>
        public string GetImageRawFormat(ImageFormat Format)
        {
            if (Format.Guid == ImageFormat.Bmp.Guid)
                return "Bmp";
            if (Format.Guid == ImageFormat.Emf.Guid)
                return "Emf";
            if (Format.Guid == ImageFormat.Exif.Guid)
                return "Exif";
            if (Format.Guid == ImageFormat.Gif.Guid)
                return "Gif";
            if (Format.Guid == ImageFormat.Icon.Guid)
                return "Icon";
            if (Format.Guid == ImageFormat.Jpeg.Guid)
                return "Jpeg";
            if (Format.Guid == ImageFormat.MemoryBmp.Guid)
                return "MemoryBmp";
            if (Format.Guid == ImageFormat.Png.Guid)
                return "Png";
            if (Format.Guid == ImageFormat.Tiff.Guid)
                return "Tiff";
            return Format.Guid == ImageFormat.Wmf.Guid ? "Wmf" : "";
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Format"></param>
        /// <returns></returns>
        public ImageFormat GetImageRawFormat(string Format)
        {
            switch (Format.ToLower())
            {
                case "bmp":
                    return ImageFormat.Bmp;
                case "emf":
                    return ImageFormat.Emf;
                case "exif":
                    return ImageFormat.Exif;
                case "gif":
                    return ImageFormat.Gif;
                case "icon":
                    return ImageFormat.Icon;
                case "jpeg":
                    return ImageFormat.Jpeg;
                case "jpg":
                    return ImageFormat.Jpeg;
                case "memorybmp":
                    return ImageFormat.MemoryBmp;
                case "png":
                    return ImageFormat.Png;
                case "tiff":
                    return ImageFormat.Tiff;
                default:
                    throw new Exception(string.Format("Unknown image RAW format name: '{0}'", Format));
            }
        }

        #endregion

    }

}
