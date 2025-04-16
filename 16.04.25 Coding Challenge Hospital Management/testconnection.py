from util.db_conn_util import DBConnUtil

def main():
    
    conn = DBConnUtil.getConnection()

    if conn:
        print("Connection is active.")
    else:
        print("Connection failed.")

if __name__ == '__main__':
    main()
