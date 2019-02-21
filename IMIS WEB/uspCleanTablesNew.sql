USE [IMIS]
GO
/****** Object:  StoredProcedure [dbo].[uspCleanTables]    Script Date: 07/12/2018 08:24:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspCleanTablesNew]
	@OffLine as int = 0		--0: For Online, 1: HF Offline, 2: CHF Offline
AS
BEGIN
	
	DECLARE @LocationId INT
	DECLARE @ParentLocationId INT

	--SELECT @ParentLocationId = ParentLocationId, @LocationId =LocationId  FROM tblLocations WHERE LocationName='Dummy' AND ValidityTo IS NULL AND LocationType = N'D'
	 
	--Phase 2
	DELETE FROM tblFeedbackPrompt;
	EXEC [UspS_ReseedTable] 'tblFeedbackPrompt';
	DELETE FROM tblReporting;
	EXEC [UspS_ReseedTable] 'tblReporting';
	DELETE FROM tblSubmittedPhotos;
	EXEC [UspS_ReseedTable] 'tblSubmittedPhotos';
	DELETE FROM dbo.tblFeedback;
	EXEC [UspS_ReseedTable] 'tblFeedback';
	DELETE FROM dbo.tblClaimServices;
	EXEC [UspS_ReseedTable] 'tblClaimServices';
	DELETE FROM dbo.tblClaimItems ;
	EXEC [UspS_ReseedTable] 'tblClaimItems';
	DELETE FROM dbo.tblClaimDedRem;
	EXEC [UspS_ReseedTable] 'tblClaimDedRem';
	DELETE FROM dbo.tblClaim;
	EXEC [UspS_ReseedTable] 'tblClaim';
	DELETE FROM dbo.tblClaimAdmin
	EXEC [USPS_ReseedTable] 'tblClaimAdmin'
	DELETE FROM dbo.tblICDCodes;
	EXEC [UspS_ReseedTable] 'tblICDCodes'
	
	
	DELETE FROM dbo.tblRelDistr;
	EXEC [UspS_ReseedTable] 'tblRelDistr';
	DELETE FROM dbo.tblRelIndex ;
	EXEC [UspS_ReseedTable] 'tblRelIndex';
	DELETE FROM dbo.tblBatchRun;
	EXEC [UspS_ReseedTable] 'tblBatchRun';
	DELETE FROM dbo.tblExtracts;
	EXEC [UspS_ReseedTable] 'tblExtracts';
	TRUNCATE TABLE tblPremium;
	
	--Phase 1
	EXEC [UspS_ReseedTable] 'tblPremium';
	DELETE FROM tblPayer;
	EXEC [UspS_ReseedTable] 'tblPayer';

	DELETE FROM dbo.tblPolicyRenewalDetails;
	EXEC [UspS_ReseedTable] 'tblPolicyRenewalDetails';
	DELETE FROM dbo.tblPolicyRenewals;
	EXEC [UspS_ReseedTable] 'tblPolicyRenewals';


	DELETE FROM tblInsureePolicy;
	EXEC [UspS_ReseedTable] 'tblInsureePolicy';
	DELETE FROM tblPolicy;
	EXEC [UspS_ReseedTable] 'tblPolicy';
	DELETE FROM tblProductItems;
	EXEC [UspS_ReseedTable] 'tblProductItems';
	DELETE FROM tblProductServices;
	EXEC [UspS_ReseedTable] 'tblProductServices';

	DELETE FROM dbo.tblRelDistr;
	EXEC [UspS_ReseedTable] 'tblRelDistr';


	DELETE FROM tblProduct;
	EXEC [UspS_ReseedTable] 'tblProduct';
	UPDATE tblInsuree set PhotoID = NULL ;
	DELETE FROM tblPhotos;
	EXEC [UspS_ReseedTable] 'tblPhotos';
	DELETE FROM tblInsuree;
	EXEC [UspS_ReseedTable] 'tblInsuree';
	DELETE FROM tblGender;
	DELETE FROM tblFamilies;
	EXEC [UspS_ReseedTable] 'tblFamilies';
	DELETE FROM tblOfficerVillages;
	EXEC [UspS_ReseedTable] 'tblOfficerVillages';
	DELETE FROM dbo.tblOfficer;
	EXEC [UspS_ReseedTable] 'tblOfficer';
	DELETE FROM dbo.tblHFCatchment;
	EXEC [UspS_ReseedTable] 'tblHFCatchment';
	DELETE FROM dbo.tblHF;
	EXEC [UspS_ReseedTable] 'tblHF';
	DELETe FROM dbo.tblPLItemsDetail;
	EXEC [UspS_ReseedTable] 'tblPLItemsDetail';
	DELETE FROM dbo.tblPLItems;
	EXEC [UspS_ReseedTable] 'tblPLItems';
	DELETE FROM dbo.tblItems;
	EXEC [UspS_ReseedTable] 'tblItems';
	DELETE FROM dbo.tblPLServicesDetail;
	EXEC [UspS_ReseedTable] 'tblPLServicesDetail';
	DELETE FROM dbo.tblPLServices;
	EXEC [UspS_ReseedTable] 'tblPLServices';
	DELETE FROM dbo.tblServices;
	EXEC [UspS_ReseedTable] 'tblServices';
	DELETE FROM dbo.tblUsersDistricts;
	EXEC [UspS_ReseedTable] 'tblUsersDistricts';


	DELETE FROM tblLocations;
	EXEC [UspS_ReseedTable] 'tblLocations';
	DELETE FROM dbo.tblLogins ;
	EXEC [UspS_ReseedTable] 'tblLogins';

	DELETE FROM dbo.tblUsers;
	EXEC [UspS_ReseedTable] 'tblUsers';

	TRUNCATE TABLE tblFromPhone;
	EXEC [UspS_ReseedTable] 'tblFromPhone';

	TRUNCATE TABLE tblEmailSettings;

	DBCC SHRINKDATABASE (0);
	
	--Drop the encryption set
	IF EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = N'EncryptionKey')
	DROP SYMMETRIC KEY EncryptionKey;
		
	IF EXISTS(SELECT * FROM sys.certificates WHERE name = N'EncryptData')
	DROP CERTIFICATE EncryptData;
	
	IF EXISTS(SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
	DROP MASTER KEY;
	
	
	
	
	
	--insert new user Admin-Admin
	IF @OffLine = 2  --CHF offline
	BEGIN
		
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[RoleID],[LanguageID],[HFID],[AuditUserID],StoredPassword,PrivateKey)
        VALUES('Admin', 'Admin', '', 'Admin', 1048576,'en',0,0
		--storedPassword
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CONCAT(CAST('Admin' AS VARCHAR(MAX)),CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2))),2)
		 -- PrivateKey
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2)
		)
       
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0, FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0, DatabaseBackupFolder = ''
        
	END
	
	
	IF @OffLine = 1 --HF offline
	BEGIN
		
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[RoleID],[LanguageID],[HFID],[AuditUserID],StoredPassword,PrivateKey)
        VALUES('Admin', 'Admin', '', 'Admin', 524288,'en',0,0
		--storedPassword
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CONCAT(CAST('Admin' AS VARCHAR(MAX)),CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2))),2)
		 -- PrivateKey
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2)
		)
        
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0,FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0, DatabaseBackupFolder = ''
        
	END
	IF @OffLine = 0 --ONLINE CREATION NEW COUNTRY NO DEFAULTS KEPT
	BEGIN
		
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[RoleID],[LanguageID],[HFID],[AuditUserID],StoredPassword,PrivateKey)
        VALUES('Admin', 'Admin', '', 'Admin',  1023,'en',0,0
		--storedPassword
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CONCAT(CAST('Admin' AS VARCHAR(MAX)),CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2))),2)
		 -- PrivateKey
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2)
		)
		
       	UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0,FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0,				DatabaseBackupFolder = ''
    END
	
	IF @OffLine = -1 --ONLINE CREATION WITH DEFAULTS KEPT AS PREVIOUS CONTENTS
	BEGIN
		
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[RoleID],[LanguageID],[HFID],[AuditUserID],StoredPassword,PrivateKey)
        VALUES('Admin', 'Admin', '', 'Admin', 1023,'en',0,0
		--storedPassword
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CONCAT(CAST('Admin' AS VARCHAR(MAX)),CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2))),2)
		 -- PrivateKey
		,CONVERT(varchar(max),HASHBYTES('SHA2_256',CAST('Admin' AS VARCHAR(MAX))),2)
		)
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0
    END


	SET IDENTITY_INSERT tblLocations ON
	INSERT INTO tblLocations(LocationId, LocationCode, Locationname, LocationType, AuditUserId, ParentLocationId) VALUES
	(1, N'R0001', N'Region', N'R', -1, NULL),
	(2, N'D0001', N'Dummy', N'D', -1, 1)
	SET IDENTITY_INSERT tblLocations OFF
		
	INSERT INTO tblUsersDistricts ([UserID],[LocationId],[AuditUserID]) VALUES (1,2,-1)
END

