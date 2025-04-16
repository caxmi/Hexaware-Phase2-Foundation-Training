import pyodbc
from util.db_property_util import DBPropertyUtil

class DBConnUtil:
    @staticmethod
    def getConnection():
        conn_str = DBPropertyUtil.getPropertyString('resources/db.properties')
        return pyodbc.connect(conn_str)
