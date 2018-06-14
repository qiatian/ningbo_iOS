//
//  FastDFSManager.m
//  IM
//
//  Created by zuo guoqing on 14-10-13.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "FastDFSManager.h"


@implementation FastDFSManager

static dispatch_once_t onceToken;
static FastDFSManager *sSharedInstance;
#pragma mark  singleton方法
+(FastDFSManager *)sharedInstance{
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[FastDFSManager alloc] init];
    });
    return sSharedInstance;
}

int writeToFileCallback(void *arg, const int64_t file_size, const char *data, \
                        const int current_size)
{
	if (arg == NULL)
	{
		return EINVAL;
	}
    
	if (fwrite(data, current_size, 1, (FILE *)arg) != 1)
	{
		return errno != 0 ? errno : EIO;
	}
    
	return 0;
}

int uploadFileCallback(void *arg, const int64_t file_size, int sock)
{
	int64_t total_send_bytes;
	char *filename;
    
	if (arg == NULL)
	{
		return EINVAL;
	}
    
	filename = (char *)arg;
	return tcpsendfile(sock, filename, file_size,g_fdfs_network_timeout, &total_send_bytes);
}


-(NSDictionary *)handleWithActionName:(NSString*)actionName localFileName:(NSString*)local_filenameStr  remoteFilename:(NSString*)remote_filenameStr groupName:(NSString*)group_nameStr{
    
    char *prefix_name;
    const char *file_ext_name;
    char slave_filename[256];
    int slave_filename_len;
    char remote_filename[256];
    char master_filename[256];
    FDFSMetaData meta_list[32];
    char szPortPart[16];
    char szDatetime[20];
    int meta_count;
    char group_name[FDFS_GROUP_NAME_MAX_LEN + 1];
    
    ConnectionInfo *pTrackerServer;
    ConnectionInfo *pStorageServer;
    int result;
    ConnectionInfo storageServer;
    int64_t file_size;
    char file_id[128];
    char file_url[256];
    char master_file_url[256];
    int url_len;
    FDFSFileInfo file_info;
    int store_path_index =0;
    
    log_init();
	g_log_context.log_level = LOG_DEBUG;

    const char*conf_filename =[[[NSBundle mainBundle] pathForResource:@"fastdsf_client.conf" ofType:nil] UTF8String];
    char local_filename[256] ;
    
    
    if ((result=fdfs_client_init(conf_filename)) != 0)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"图片fdfs_client_init失败",@"message", nil];
    }
    
    pTrackerServer = tracker_get_connection();
    if (pTrackerServer == NULL)
    {
        fdfs_client_destroy();
        if (errno!=0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:errno],@"code", @"图片tracker_get_connection失败",@"message", nil];
        }else{
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ECONNREFUSED],@"code", @"图片服务器拒绝",@"message", nil];
        }
    }
    
    pStorageServer = NULL;
    *group_name = '\0';

    if ([actionName isEqualToString:@"upload"]) {
        
        strcpy(local_filename, [local_filenameStr UTF8String]);
        
        {
            ConnectionInfo storageServers[FDFS_MAX_SERVERS_EACH_GROUP];
            ConnectionInfo *pServer;
            ConnectionInfo *pServerEnd;
            int storage_count;
            
            if ((result=tracker_query_storage_store_list_without_group( \
                                                                       pTrackerServer, storageServers, \
                                                                       FDFS_MAX_SERVERS_EACH_GROUP, &storage_count, \
                                                                       group_name, &store_path_index)) == 0)
            {
                printf("tracker_query_storage_store_list_without_group: \n");
                pServerEnd = storageServers + storage_count;
                for (pServer=storageServers; pServer<pServerEnd; pServer++)
                {
                    printf("\tserver %d. group_name=%s, " \
                           "ip_addr=%s, port=%d\n", \
                           (int)(pServer - storageServers) + 1, \
                           group_name, pServer->ip_addr, pServer->port);
                }
                printf("\n");
            }
        }
        
        if ((result=tracker_query_storage_store(pTrackerServer, \
                                                &storageServer, group_name, &store_path_index)) != 0)
        {
            fdfs_client_destroy();
            printf("tracker_query_storage fail, " \
                   "error no: %d, error info: %s\n", \
                   result, STRERROR(result));
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"上传图片tracker_query_storage_store失败",@"message", nil];;
        }
        
        printf("group_name=%s, ip_addr=%s, port=%d\n", \
               group_name, storageServer.ip_addr, \
               storageServer.port);
        
        if ((pStorageServer=tracker_connect_server(&storageServer, \
                                                   &result)) == NULL)
        {
            fdfs_client_destroy();
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"上传图片tracker_connect_server失败",@"message", nil];
        }
        
        
        
        
        *group_name = '\0';
        
        memset(&meta_list, 0, sizeof(meta_list));
        meta_count = 0;
        strcpy(meta_list[meta_count].name, "fileName");
        strcpy(meta_list[meta_count].value, local_filename);
        meta_count++;
        
        strcpy(meta_list[meta_count].name, "fileExtName");
        file_ext_name = fdfs_get_file_ext_name(local_filename);
        strcpy(meta_list[meta_count].value, file_ext_name);
        meta_count++;
    
        strcpy(meta_list[meta_count].name, "fileLength");
        
        struct stat stat_buf;
        if (stat(local_filename, &stat_buf) == 0 && \
            S_ISREG(stat_buf.st_mode))
        {
            file_size = stat_buf.st_size;
            strcpy(meta_list[meta_count].value, [[NSString stringWithFormat:@"%lld",file_size] UTF8String]);
            
            meta_count++;
            
            result = storage_upload_by_callback(pTrackerServer, \
                                                pStorageServer, store_path_index, \
                                                uploadFileCallback, local_filename, \
                                                file_size, file_ext_name, \
                                                meta_list, meta_count, \
                                                group_name, remote_filename);
        }
        
        printf("storage_upload_by_callback\n");
        
        
        if (result != 0)
        {
            printf("upload file fail, " \
                   "error no: %d, error info: %s\n", \
                   result, STRERROR(result));
            tracker_disconnect_server_ex(pStorageServer, true);
            fdfs_client_destroy();
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"上传图片storage_upload_by_callback失败",@"message", nil];
        }
        

        if (g_tracker_server_http_port == 80 || g_tracker_server_http_port ==8080)
        {
            *szPortPart = '\0';
        }
        else
        {
            sprintf(szPortPart, ":%d", g_tracker_server_http_port);
        }
        
        sprintf(file_id, "%s/%s", group_name, remote_filename);
        url_len = sprintf(file_url, "http://%s%s/%s", \
                          pStorageServer->ip_addr, szPortPart, file_id);
        
        printf("group_name=%s, remote_filename=%s\n", \
               group_name, remote_filename);
        
        fdfs_get_file_info(group_name, remote_filename, &file_info);
        printf("source ip address: %s\n", file_info.source_ip_addr);
        printf("file timestamp=%s\n", formatDatetime(
                                                     file_info.create_timestamp, "%Y-%m-%d %H:%M:%S", \
                                                     szDatetime, sizeof(szDatetime)));
        printf("file size=%lld", file_info.file_size);
        printf("file crc32=%u\n", file_info.crc32);
        printf("example file url: %s\n", file_url);
        strcpy(master_file_url, file_url);
        
        strcpy(master_filename, remote_filename);
        *remote_filename = '\0';
        
        
        /*//slave
        {
            struct stat stat_buf;
            
            prefix_name = "-small";
            if (stat(local_filename, &stat_buf) == 0 && \
                S_ISREG(stat_buf.st_mode))
            {
                file_size = stat_buf.st_size;
                result = storage_upload_slave_by_callback(pTrackerServer, \
                                                          NULL, uploadFileCallback, &local_filename, \
                                                          file_size, master_filename, prefix_name, \
                                                          file_ext_name, meta_list, meta_count, \
                                                          group_name, remote_filename);
            }
            
            printf("storage_upload_slave_by_callback\n");
        }
        
        if (result != 0)
        {
            printf("upload slave file fail, " \
                   "error no: %d, error info: %s\n", \
                   result, STRERROR(result));
            tracker_disconnect_server_ex(pStorageServer, true);
            fdfs_client_destroy();
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"上传图片storage_upload_slave_by_callback失败",@"message", nil];
        }
        
        if (g_tracker_server_http_port == 80 || g_tracker_server_http_port ==8080)
        {
            *szPortPart = '\0';
        }
        else
        {
            sprintf(szPortPart, ":%d", g_tracker_server_http_port);
        }
        
        sprintf(file_id, "%s/%s", group_name, remote_filename);
        url_len = sprintf(file_url, "http://%s%s/%s", \
                          pStorageServer->ip_addr, szPortPart, file_id);
        
        
        printf("group_name=%s, remote_filename=%s\n", \
               group_name, remote_filename);
        
        fdfs_get_file_info(group_name, remote_filename, &file_info);
        
        printf("source ip address: %s\n", file_info.source_ip_addr);
        printf("file timestamp=%s\n", formatDatetime(
                                                     file_info.create_timestamp, "%Y-%m-%d %H:%M:%S", \
                                                     szDatetime, sizeof(szDatetime)));
        printf("file crc32=%u\n", file_info.crc32);
        printf("example file url: %s\n", file_url);
        
        if (fdfs_gen_slave_filename(master_filename, \
                                    prefix_name, file_ext_name, \
                                    slave_filename, &slave_filename_len) == 0)
        {
            
            if (strcmp(remote_filename, slave_filename) != 0)
            {
                printf("slave_filename=%s\n" \
                       "remote_filename=%s\n" \
                       "not equal!\n", \
                       slave_filename, remote_filename);
            }
        }
         
         */

    }else if ([actionName isEqualToString:@"delete"]){
        
        strcpy(remote_filename, [remote_filenameStr UTF8String]);
        strcpy(group_name, [group_nameStr UTF8String]);
        
        result = tracker_query_storage_update(pTrackerServer, \
                                              &storageServer, group_name, remote_filename);
        if (result != 0)
        {
            fdfs_client_destroy();
            
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"删除图片tracker_query_storage_update失败",@"message", nil];
        }
        
        printf("storage=%s:%d\n", storageServer.ip_addr, \
               storageServer.port);
        
        if ((pStorageServer=tracker_connect_server(&storageServer, \
                                                   &result)) == NULL)
        {
            fdfs_client_destroy();
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"删除图片tracker_connect_server失败",@"message", nil];
        }
        
        if ((result=storage_delete_file(pTrackerServer, \
                                        NULL, group_name, remote_filename)) == 0)
        {
            printf("delete file success\n");
        }
        else
        {
            fdfs_client_destroy();
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", @"删除图片storage_delete_file失败",@"message", nil];
        }

    }
    
    
    /* for test only */
	if ((result=fdfs_active_test(pTrackerServer)) != 0)
	{
		printf("active_test to tracker server %s:%d fail, errno: %d\n", \
               pTrackerServer->ip_addr, pTrackerServer->port, result);
	}
    
	/* for test only */
	if ((result=fdfs_active_test(pStorageServer)) != 0)
	{
		printf("active_test to storage server %s:%d fail, errno: %d\n", \
               pStorageServer->ip_addr, pStorageServer->port, result);
	}
    
	tracker_disconnect_server_ex(pStorageServer, true);
	tracker_disconnect_server_ex(pTrackerServer, true);
    
	fdfs_client_destroy();
    
    
    if([actionName isEqualToString:@"upload"]){
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code", [NSString stringWithUTF8String:master_file_url],@"masterUrl",[NSString stringWithUTF8String:master_filename],@"masterFileName", [NSNumber numberWithLongLong:file_info.file_size],@"fileSize",[NSString stringWithUTF8String:group_name],@"groupName", nil];
    }else if([actionName isEqualToString:@"delete"]){
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:result],@"code",@"删除图片成功",@"message", nil];
    }else{
        return [NSDictionary dictionary];
    }
	
}

@end
