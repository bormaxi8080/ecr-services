using System;
using System.Data;
using System.Data.SqlClient;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// ����� ������������� ������ � ������� �������� �������� ������� � ��������� ECR
    /// </summary>
    public class ECRSourceCatalogEntityChecker : IECRSourceCatalogEntityChecker
    {

// ReSharper disable InconsistentNaming
        /// <summary>
        /// ECRSourceCatalogEntityChecker() class source sql connection
        /// </summary>
        protected SqlConnection _conn = new SqlConnection();
        /// <summary>
        /// WebCatalogEntityChecker() class source sql command
        /// </summary>
        protected SqlCommand _cmd = new SqlCommand();
// ReSharper restore InconsistentNaming

        /// <summary>
        /// ����������� ������ WebCatalogEntityChecker()
        /// </summary>
        /// <param name="ConnectionString">������ ���������� � ����� ������</param>
        public ECRSourceCatalogEntityChecker(string ConnectionString)
        {
            _conn.ConnectionString = ConnectionString;
            _cmd.CommandType = CommandType.StoredProcedure;
            _cmd.Connection = _conn;
        }

        /// <summary>
        /// ������� ���������� �������� ������� ������� � ��������� ����������� � �������� ���������
        /// </summary>
        /// <param name="KeyType">��� ����� ������� ��� ������</param>
        /// <param name="KeyValue">�������� �����</param>
        /// <param name="EntityType">��� ��������</param>
        /// <returns>true ���� ������� � ��������� ����������� ������� � �������� ���������, false � ��������� ������</returns>
        public bool CheckItemExists(string KeyType, string KeyValue, string EntityType)
        {

            bool result;
            _cmd.Parameters.Clear();

            // �������� ��������� [ecr].CheckSourceCatalogWareItemExists ���������� ���������� �������,
            //      ��������������� �������� ��������� ������ (KeyType, KeyValue, EntityType);
            // � ������, ���� KeyType �� �������������� ��� ����������, ������������ ������;
            _cmd.CommandText = "[ecr].CheckSourceCatalogEntityItemExists";

            _cmd.Parameters.AddWithValue("KeyType", KeyType);
            _cmd.Parameters.AddWithValue("KeyValue", KeyValue);

            // ��� ������ ������������� ������ � ��� ������, ���� ������, � ����� ��������� ������� ������ �������� �������;
            if (EntityType != string.Empty)
                _cmd.Parameters.AddWithValue("EntityType", EntityType);
            else
                _cmd.Parameters.AddWithValue("EntityType", DBNull.Value);

            // �������� ��������� ���������� �������� ���� bit:
            //      1 (true) : ������ � ������� ������� � �������� ���������;
            //      0 (false): ������ � ������ �� �������;
            // � ������, ���� ���������� ������� ������ 1, �������� ��������� ���������� ������;
            _conn.Open();
            try
            {
                //_result = (bool)_cmd.ExecuteScalar();
                result = Convert.ToBoolean(_cmd.ExecuteScalar());
            }
            finally
            {
                _conn.Close();
            }

             return result;

        }

        /// <summary>
        /// ������� ������������ �������� ����� ��������� ���� ��� ������� � ��������� ����������� � ������� � ������ �������� ����� �������� ����
        /// </summary>
        /// <param name="KeyType">������������� ��������� ���� �����</param>
        /// <param name="KeyValue">�������� �����</param>
        /// <param name="EntityType">��� ��������</param>
        /// <param name="LookKeyType">������������� �������� ���� �����</param>
        /// <returns>�������� ����� �������� ����</returns>
        public string CompareKeys(string KeyType, string KeyValue, string EntityType, string LookKeyType)
        {

            string result;
            _cmd.Parameters.Clear();

            // �������� ��������� [ecr].SourceCatalogEntityItemCompareKeys ���������� �������� ����� ���������� ���� LookKeyType,
            //      ����������������� �������� ��������� ������ �������� ������� (KeyType, KeyValue, EntityType);
            // � ������, ���� ��� ����� (KeyType, LookKeyType) �� �������������� ��� ����������, ������������ exception;
            _cmd.CommandText = "[ecr].SourceCatalogEntityItemCompareKeys";

            _cmd.Parameters.AddWithValue("KeyType", KeyType);
            _cmd.Parameters.AddWithValue("KeyValue", KeyValue);

            // �������� LookForKey ������ ��� �������� �����, ���������� ����������������� ��������� ������� � �������� ��������;
            _cmd.Parameters.AddWithValue("LookKeyType", LookKeyType);

            // �������� ���� ������ ������������� ������ � ��� ������, ���� ������, � ����� ��������� ������� ������ �����;
            if (EntityType != string.Empty)
                _cmd.Parameters.AddWithValue("EntityType", EntityType);
            else
                _cmd.Parameters.AddWithValue("EntityType", DBNull.Value);

            // �������� ��������� ���������� �������� ���������� ����� - ��� ������: nvarchar(255);
            // � ������, ���� ����� �������� ������� ��� ��� ���������� ������ ������ 1, ������������ exception;
            _conn.Open();
            try
            {
                result = (string)_cmd.ExecuteScalar();
            }
            finally
            {
                _conn.Close();
            }

            return result;
            
        }

    }

}
