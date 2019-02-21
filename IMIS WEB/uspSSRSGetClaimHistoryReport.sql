IF NOT OBJECT_ID('uspSSRSGetClaimHistoryReport') IS NULL 
DROP PROCEDURE uspSSRSGetClaimHistoryReport
GO
CREATE PROCEDURE [dbo].[uspSSRSGetClaimHistoryReport]
(
	@HFID INT,
	@LocationId INT,
	@ProdId INT, 
	@StartDate DATE, 
	@EndDate DATE,
	@ClaimStatus INT = NULL,
	@InsuranceNumber NVARCHAR(12),
	@Scope INT= NULL
	
)
AS
BEGIN
     /*
	RESPONSE CODES
		1 - Insurance number not found
		0 - Success 
		-1 Unknown Error
	*/


	-- Check Insurance number if exsists
	
	    IF NOT EXISTS(SELECT 1 FROM tblInsuree WHERE CHFID=@InsuranceNumber AND ValidityTo IS NULL) 
	     
		RETURN 1 
		
		IF @Scope =2 OR @Scope = -1
		BEGIN
		;WITH TotalForItems AS
			(
				SELECT C.ClaimId, SUM(CI.PriceAsked * CI.QtyProvided)Claimed,
				SUM(ISNULL(CI.PriceApproved, CI.PriceAsked) * ISNULL(CI.QtyApproved, CI.QtyProvided)) Approved,
				SUM(CI.PriceValuated)Adjusted,
				SUM(CI.RemuneratedAmount)Remunerated
				FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CI.ValidityTo IS NULL
				GROUP BY C.ClaimID
			), TotalForServices AS
			(
				SELECT C.ClaimId, SUM(CS.PriceAsked * CS.QtyProvided)Claimed,
				SUM(ISNULL(CS.PriceApproved, CS.PriceAsked) * ISNULL(CS.QtyApproved, CS.QtyProvided)) Approved,
				SUM(CS.PriceValuated)Adjusted,
				SUM(CS.RemuneratedAmount)Remunerated
				FROM tblClaim C 
				LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CS.ValidityTo IS NULL
				GROUP BY C.ClaimID
			)

			SELECT R.RegionId,R.RegionName,D.DistrictId,D.DistrictName, C.DateClaimed, PROD.ProductCode +' ' + PROD.ProductName Product, C.ClaimID, I.ItemId, S.ServiceID, HF.HFCode, HF.HFName, C.ClaimCode, C.DateClaimed, CA.LastName + ' ' + CA.OtherNames ClaimAdminName,
			C.DateFrom, C.DateTo, Ins.CHFID, Ins.LastName + ' ' + Ins.OtherNames InsureeName,
			CASE C.ClaimStatus WHEN 1 THEN N'Rejected' WHEN 2 THEN N'Entered' WHEN 4 THEN N'Checked' WHEN 8 THEN N'Processed' WHEN 16 THEN N'Valuated' END ClaimStatus,
			C.RejectionReason, COALESCE(TFI.Claimed + TFS.Claimed, TFI.Claimed, TFS.Claimed) Claimed, 
			COALESCE(TFI.Approved + TFS.Approved, TFI.Approved, TFS.Approved) Approved,
			COALESCE(TFI.Adjusted + TFS.Adjusted, TFI.Adjusted, TFS.Adjusted) Adjusted,
			COALESCE(TFI.Remunerated + TFS.Remunerated, TFI.Remunerated, TFS.Remunerated)Paid,
			CASE WHEN CI.RejectionReason <> 0 THEN I.ItemCode ELSE NULL END RejectedItem, CI.RejectionReason ItemRejectionCode,
			CASE WHEN CS.RejectionReason > 0 THEN S.ServCode ELSE NULL END RejectedService, CS.RejectionReason ServiceRejectionCode,
			CASE WHEN CI.QtyProvided <> COALESCE(CI.QtyApproved,CI.QtyProvided) THEN I.ItemCode ELSE NULL END AdjustedItem,
			CASE WHEN CI.QtyProvided <> COALESCE(CI.QtyApproved,CI.QtyProvided) THEN CI.QtyProvided ELSE NULL END OrgQtyItem,
			CASE WHEN CI.QtyProvided <> COALESCE(CI.QtyApproved ,CI.QtyProvided)THEN CI.QtyApproved ELSE NULL END AdjQtyItem,
			CASE WHEN CS.QtyProvided <> COALESCE(CS.QtyApproved,CS.QtyProvided) THEN S.ServCode ELSE NULL END AdjustedService,
			CASE WHEN CS.QtyProvided <> COALESCE(CS.QtyApproved,CS.QtyProvided) THEN CS.QtyProvided ELSE NULL END OrgQtyService,
			CASE WHEN CS.QtyProvided <> COALESCE(CS.QtyApproved ,CS.QtyProvided)THEN CS.QtyApproved ELSE NULL END AdjQtyService,
			C.Explanation


			FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
			LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
			LEFT OUTER JOIN tblItems I ON CI.ItemId = I.ItemID
			LEFT OUTER JOIN tblProduct PROD ON PROD.ProdID = CI.ProdID
			LEFT OUTER JOIN tblServices S ON CS.ServiceID = S.ServiceID
			INNER JOIN tblHF HF ON C.HFID = HF.HfID
			LEFT OUTER JOIN tblDistricts D ON D.DistrictId =HF.LocationId
			LEFT OUTER JOIN tblRegions R ON R.RegionId = D.Region
			LEFT OUTER JOIN tblClaimAdmin CA ON C.ClaimAdminId = CA.ClaimAdminId
			INNER JOIN tblInsuree Ins ON C.InsureeId = Ins.InsureeId
			LEFT OUTER JOIN TotalForItems TFI ON C.ClaimId = TFI.ClaimID
			LEFT OUTER JOIN TotalForServices TFS ON C.ClaimId = TFS.ClaimId

			WHERE C.ValidityTo IS NULL
			AND ISNULL(C.DateTo,C.DateFrom) BETWEEN @StartDate AND @EndDate
			AND (C.ClaimStatus = @ClaimStatus OR @ClaimStatus IS NULL)
			AND HF.LocationId = @LocationId OR @LocationId = 0
			AND (CI.ProdID = @ProdId OR CS.ProdID = @ProdId  OR COALESCE(CS.ProdID, CI.ProdId) IS NULL OR @ProdId = 0) 
			--OR  (CI.ProdID IS NOT NULL OR CS.ProdID IS NOT NULL)	-- --Added by Rogers
			AND (Ins.CHFID = @InsuranceNumber)
			AND HF.HFID = @HFID

		IF @Scope =0
		 BEGIN
			;WITH TotalForItems AS
			(
				SELECT C.ClaimId, SUM(CI.PriceAsked * CI.QtyProvided)Claimed,
				SUM(ISNULL(CI.PriceApproved, CI.PriceAsked) * ISNULL(CI.QtyApproved, CI.QtyProvided)) Approved,
				SUM(CI.PriceValuated)Adjusted,
				SUM(CI.RemuneratedAmount)Remunerated
				FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CI.ValidityTo IS NULL
				GROUP BY C.ClaimID
			), TotalForServices AS
			(
				SELECT C.ClaimId, SUM(CS.PriceAsked * CS.QtyProvided)Claimed,
				SUM(ISNULL(CS.PriceApproved, CS.PriceAsked) * ISNULL(CS.QtyApproved, CS.QtyProvided)) Approved,
				SUM(CS.PriceValuated)Adjusted,
				SUM(CS.RemuneratedAmount)Remunerated
				FROM tblClaim C 
				LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CS.ValidityTo IS NULL
				GROUP BY C.ClaimID
			)

			SELECT R.RegionId,R.RegionName,D.DistrictId,D.DistrictName, C.DateClaimed,PROD.ProductCode +' ' + PROD.ProductName Product, C.ClaimID, I.ItemId, S.ServiceID, HF.HFCode, HF.HFName, C.ClaimCode, C.DateClaimed, CA.LastName + ' ' + CA.OtherNames ClaimAdminName,
			C.DateFrom, C.DateTo, Ins.CHFID, Ins.LastName + ' ' + Ins.OtherNames InsureeName,
			CASE C.ClaimStatus WHEN 1 THEN N'Rejected' WHEN 2 THEN N'Entered' WHEN 4 THEN N'Checked' WHEN 8 THEN N'Processed' WHEN 16 THEN N'Valuated' END ClaimStatus,
			COALESCE(TFI.Claimed + TFS.Claimed, TFI.Claimed, TFS.Claimed) Claimed, 
			COALESCE(TFI.Approved + TFS.Approved, TFI.Approved, TFS.Approved) Approved,
			COALESCE(TFI.Adjusted + TFS.Adjusted, TFI.Adjusted, TFS.Adjusted) Adjusted,
			COALESCE(TFI.Remunerated + TFS.Remunerated, TFI.Remunerated, TFS.Remunerated)Paid


			FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
			LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
			LEFT OUTER JOIN tblProduct PROD ON PROD.ProdID =@ProdId
			LEFT OUTER JOIN tblItems I ON CI.ItemId = I.ItemID
			LEFT OUTER JOIN tblServices S ON CS.ServiceID = S.ServiceID
			INNER JOIN tblHF HF ON C.HFID = HF.HfID
			LEFT OUTER JOIN tblDistricts D ON D.DistrictId = HF.LocationId
			LEFT OUTER JOIN tblRegions R ON R.RegionId = D.Region
			LEFT OUTER JOIN tblClaimAdmin CA ON C.ClaimAdminId = CA.ClaimAdminId
			INNER JOIN tblInsuree Ins ON C.InsureeId = Ins.InsureeId
			LEFT OUTER JOIN TotalForItems TFI ON C.ClaimId = TFI.ClaimID
			LEFT OUTER JOIN TotalForServices TFS ON C.ClaimId = TFS.ClaimId

			
			WHERE C.ValidityTo IS NULL
			AND ISNULL(C.DateTo,C.DateFrom) BETWEEN @StartDate AND @EndDate
			AND (C.ClaimStatus = @ClaimStatus OR @ClaimStatus IS NULL)
			AND HF.LocationId = @LocationId OR @LocationId = 0
			AND (CI.ProdID = @ProdId OR CS.ProdID = @ProdId  OR COALESCE(CS.ProdID, CI.ProdId) IS NULL OR @ProdId = 0) 
			--OR  (CI.ProdID IS NOT NULL OR CS.ProdID IS NOT NULL)	-- --Added by Rogers
			AND (Ins.CHFID = @InsuranceNumber)
			--AND C.ClaimStatus=(CASE @Scope WHEN 1 THEN 4 END)
			AND HF.HFID = @HFID
		END
		IF @Scope =1
		BEGIN
		;WITH TotalForItems AS
			(
				SELECT C.ClaimId, SUM(CI.PriceAsked * CI.QtyProvided)Claimed,
				SUM(ISNULL(CI.PriceApproved, CI.PriceAsked) * ISNULL(CI.QtyApproved, CI.QtyProvided)) Approved,
				SUM(CI.PriceValuated)Adjusted,
				SUM(CI.RemuneratedAmount)Remunerated
				FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CI.ValidityTo IS NULL
				GROUP BY C.ClaimID
			), TotalForServices AS
			(
				SELECT C.ClaimId, SUM(CS.PriceAsked * CS.QtyProvided)Claimed,
				SUM(ISNULL(CS.PriceApproved, CS.PriceAsked) * ISNULL(CS.QtyApproved, CS.QtyProvided)) Approved,
				SUM(CS.PriceValuated)Adjusted,
				SUM(CS.RemuneratedAmount)Remunerated
				FROM tblClaim C 
				LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
				WHERE C.ValidityTo IS NULL
				AND CS.ValidityTo IS NULL
				GROUP BY C.ClaimID
			)

			SELECT R.RegionId,R.RegionName,D.DistrictId,D.DistrictName, C.DateClaimed,PROD.ProductCode +' ' + PROD.ProductName Product, C.ClaimID, I.ItemId, S.ServiceID, HF.HFCode, HF.HFName, C.ClaimCode, C.DateClaimed, CA.LastName + ' ' + CA.OtherNames ClaimAdminName,
			C.DateFrom, C.DateTo, Ins.CHFID, Ins.LastName + ' ' + Ins.OtherNames InsureeName,
			CASE C.ClaimStatus WHEN 1 THEN N'Rejected' WHEN 2 THEN N'Entered' WHEN 4 THEN N'Checked' WHEN 8 THEN N'Processed' WHEN 16 THEN N'Valuated' END ClaimStatus,
			C.RejectionReason, COALESCE(TFI.Claimed + TFS.Claimed, TFI.Claimed, TFS.Claimed) Claimed, 
			COALESCE(TFI.Approved + TFS.Approved, TFI.Approved, TFS.Approved) Approved,
			COALESCE(TFI.Adjusted + TFS.Adjusted, TFI.Adjusted, TFS.Adjusted) Adjusted,
			COALESCE(TFI.Remunerated + TFS.Remunerated, TFI.Remunerated, TFS.Remunerated)Paid,
			CASE WHEN CI.RejectionReason <> 0 THEN I.ItemCode ELSE NULL END RejectedItem, CI.RejectionReason ItemRejectionCode,
			CASE WHEN CS.RejectionReason > 0 THEN S.ServCode ELSE NULL END RejectedService, CS.RejectionReason ServiceRejectionCode


			FROM tblClaim C LEFT OUTER JOIN tblClaimItems CI ON C.ClaimId = CI.ClaimID
			LEFT OUTER JOIN tblClaimServices CS ON C.ClaimId = CS.ClaimID
			LEFT OUTER JOIN tblProduct PROD ON PROD.ProdID =CI.ProdID
			LEFT OUTER JOIN tblItems I ON CI.ItemId = I.ItemID
			LEFT OUTER JOIN tblServices S ON CS.ServiceID = S.ServiceID
			INNER JOIN tblHF HF ON C.HFID = HF.HfID
		    
			LEFT OUTER JOIN tblDistricts D ON D.DistrictId = HF.LocationId
			LEFT OUTER JOIN tblRegions R ON R.RegionId = D.Region
			LEFT OUTER JOIN tblClaimAdmin CA ON C.ClaimAdminId = CA.ClaimAdminId
			INNER JOIN tblInsuree Ins ON C.InsureeId = Ins.InsureeId
			LEFT OUTER JOIN TotalForItems TFI ON C.ClaimId = TFI.ClaimID
			LEFT OUTER JOIN TotalForServices TFS ON C.ClaimId = TFS.ClaimId
		
			WHERE C.ValidityTo IS NULL
			AND ISNULL(C.DateTo,C.DateFrom) BETWEEN @StartDate AND @EndDate
			AND (C.ClaimStatus = @ClaimStatus OR @ClaimStatus IS NULL)
			AND HF.LocationId = @LocationId OR @LocationId = 0
			AND (CI.ProdID = @ProdId OR CS.ProdID = @ProdId  OR COALESCE(CS.ProdID, CI.ProdId) IS NULL OR @ProdId = 0) 
			--OR  (CI.ProdID IS NOT NULL OR CS.ProdID IS NOT NULL)	-- --Added by Rogers
			AND (Ins.CHFID = @InsuranceNumber)
			AND HF.HFID = @HFID
		END

		

		END

		

END

GO