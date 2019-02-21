''Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)
''
''The program users must agree to the following terms:
''
''Copyright notices
''This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
''Free Software Foundation, version 3 of the License.
''This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
''MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.
''
''Disclaimer of Warranty
''There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
''holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
''limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
''performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.
''
''Limitation of Liability 
''In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
''conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
''arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
''sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
''advised of the possibility of such damages.
''
''In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.
'
' 
'

Public Class Enums


    Enum Rights

        '****************************************Insuree and Policy  10 00 00
        'Family
        Family = 101000
        FindFamily = 101001
        AddFamily = 101002
        EditFamily = 101003
        DeleteFamily = 101004
        ViewFamily = 101001

        'Insuree
        Insuree = 101100
        FindInsuree = 101101
        AddInsuree = 101102
        EditInsuree = 101103
        DeleteInsuree = 101104
        EnquireInsuree = 101105             'NEW

        'Policy
        FindPolicy = 101201
        AddPolicy = 101202
        EditPolicy = 101203
        DeletePolicy = 101204
        RenewPolicy = 101205
        ViewPolicy = 101201

        'Contribution
        FindContribution = 101301           'NEW
        AddContribution = 101302            'NEW
        EditContribution = 101303           'NEW    
        DeleteContribution = 101304         'NEW
        ViewContribution = 101301           'NEW 

        'Payment
        FindPayment = 101401
        AddPayment = 101402
        EditPayment = 101403
        DeletePayment = 101404

        '***************************************Claims     11 00 00

        'Claims
        FindClaim = 111001
        EnterClaim = 111002
        EditClaim = 111003
        DeleteClaim = 111004
        LoadClaim = 111005
        PrintClaim = 111006                  'NEW
        SubmitClaim = 111007                 'NEW
        ReviewClaim = 111008
        Feedback = 111009
        UpdateClaims = 111010
        ProcessClaims = 111011
        Filter = 111012
        Preview = 111013
        'ClaimsBatchClosure = 111014
        'ClaimOverview = 111015

        'Batch
        Batch = 111100
        ValuateClaim = 111101               'Include to Access batch run page
        BatchProcess = 111102
        BatchFilter = 111103                'NEW
        BatchPreview = 111104

        '***************************************Administrations 12 00 00

        'Product
        Product = 121000
        FindProduct = 121001
        AddProduct = 121002
        EditProduct = 121003
        DeleteProduct = 121004
        DuplicateProduct = 121005
        ViewProduct = 121001

        'Health Facilities
        HealthFacility = 121100
        FindHealthFacility = 121101
        AddHealthFacility = 121102
        EditHealthFacility = 121103
        DeleteHealthFacility = 121104

        'PriceLists Medical Services
        PriceListMedicalServices = 121200
        FindPriceListMedicalServices = 121201
        AddPriceListMedicalServices = 121202
        EditPriceListMedicalServices = 121203
        DeletePriceListMedicalServices = 121204
        DuplicatePriceListMedicalServices = 121205

        'Pricelists Medical Items
        PriceListMedicalItems = 121300
        FindPriceListMedicalItems = 121301
        AddPriceListMedicalItems = 121302
        EditPriceListMedicalItems = 121303
        DeletePriceListMedicalItems = 121304
        DuplicatePriceListMedicalItems = 121305

        'Medical Services
        MedicalService = 121400
        FindMedicalService = 121401
        AddMedicalService = 121402
        EditMedicalService = 121403
        DeleteMedicalService = 121404

        'Medical Item
        MedicalItem = 122100
        FindMedicalItem = 122101
        AddMedicalItem = 122102
        EditMedicalItem = 122103
        DeleteMedicalItem = 122104

        'Enrolment Officers
        Officer = 121500
        FindOfficer = 121501
        AddOfficer = 121502
        EditOfficer = 121503
        DeleteOfficer = 121504

        'claim administrator
        ClaimAdministrator = 121600
        FindClaimAdministrator = 121601
        AddClaimAdministrator = 121602
        EditClaimAdministrator = 121603
        DeleteClaimAdministrator = 121604

        'Users
        Users = 121700
        FindUser = 121701
        AddUser = 121702
        EditUser = 121703
        DeleteUser = 121704

        'Payers
        Payer = 121800
        FindPayer = 121801
        AddPayer = 121802
        EditPayer = 121803
        DeletePayer = 121804
        ViewPayer = 121801

        'locations
        Locations = 121900
        FindLocations = 121901
        AddDistrict = 121902
        EditDistrict = 121903
        DeleteDistrict = 121904

        'UserProfile
        userProfiles = 122000
        FindUserProfile = 122001
        AddUserProfile = 122002
        DeleteUserProfile = 122004
        EditUserProfile = 122003
        DuplicateUserProfile = 122005

        '****************************************Tools 13 00 00
        '--
        '--

        '****************************************Registers 14 00 00
        DiagnosesUpload = 141001                'NEW
        DiagnosesDownload = 141002              'NEW

        HealthFacilitiesUpload = 1411001        'NEW
        HealthFacilitiesDownload = 141102       'NEW

        LocationUpload = 141201                 'NEW
        LocationDonwload = 141202               'NEW

        '****************************************Extracts 15 00 00
        Extracts = 150000
        'Master Data
        MasterDataDownload = 151001             'NEW

        'Phone Extract
        PhoneExtractsCreate = 151101            'NEW

        'Offline Extract
        OfflineExtractCreate = 151201           'NEW

        'Claims
        ClaimXMLUpload = 151301

        'Enrolment
        EnrolmentsUpload = 151401               'NEW

        'Feedback
        FeedbackUpload = 151501                 'NEW

        '****************************************Reports 16 00 00
        'Reports
        Reports = 160000                              ' Add to include all reports                
        PrimaryOperationalIndicatorPolicies = 160001  'NEW 
        PrimaryOperationalIndicatorsClaims = 160002   'NEW
        DerivedOperationalIndicators = 160003         'NEW
        ContributionCollection = 160004               'NEW
        ProductSales = 160005                         'NEW
        ContributionDistribution = 160006             'NEW
        UserActivity = 160007                         'NEW
        EnrolmentPerformanceIndicators = 160008       'NEW
        StatusOfRegister = 160009                     'NEW
        InsureeWithoutPhotos = 160010
        PaymentCategoryOverview = 160011              'NEW
        MatchingFunds = 160012
        ClaimOverviewReport = 160013
        PercentageReferrals = 160014
        FamiliesInsureesOverview = 160015
        PendingInsurees = 160016
        Renewals = 160017
        CapitationPayment = 160018
        RejectedPhoto = 160019
        ContributionPayment = 160020                  'NEW
        ControlNumberAssignment = 160021              'NEW 
        OverviewOfCommissions = 160022
        ClaimHistoryReport = 160023
        '-ViewReport = 160007

        '****************************************Utilities/Email Setting 17 00 00 
        Utilities = 170000
        DatabaseBackup = 170001
        DatabaseRestore = 170002
        ExecuteScripts = 170003
        EmailSettings = 170004

        '****************************************Funding 18 00 00  
        AddFund = 181001

        '**********************************************************************************END***************************************************


        'IN LEGACY START 
        SelectClaimForReview = 111016
        EnterFeedback = 111009
        'ValuateClaim = 111017 Amended on top
        ' NEW starts 
        SelectClaimForFeedback = 111009
        OverviewFamily = 101005
        ChangeFamilyHead = 101005
        MovingInsuree = 101006
        'Ward
        AddWard = 121902
        EditWard = 121903
        DeleteWard = 121904

        'Village
        AddVillage = 121902
        EditVillage = 121903
        DeleteVillage = 121904
        ' NEW end

        FeedbackPrompt = 191001                 'NOT IN THE NEW DOCUMENT 
        UploadICD = 191002                      'NOT IN THE NEW DOCUMENT  

        OfflineExtracts
        OfflineClaims
        OfflineEnrolments

        'IN LEGACY END


    End Enum

    Enum Pages
        Home

        'policy & insurance
        FindFamily
        Family
        ChangeFamily
        OverviewFamily
        FindInsuree
        Insuree
        FindPolicy
        Policy
        FindPremium
        Premium
        FindPayment

        'claims
        FindClaim
        ClaimOverview
        Claim
        ClaimFeedback
        ClaimReview
        ProcessBatches

        'administration
        FindProduct
        Product
        HealthFacility
        FindHealthFacility
        FindPriceListMI
        PriceListMI
        FindPriceListMS
        PriceListMS
        FindMedicalItem
        MedicalItem
        FindMedicalService
        MedicalService
        FindUser
        User
        UserProfiles
        Role
        FindOfficer
        Officer
        FindClaimAdministrator
        ClaimAdministrator
        FindPayer
        Payer
        Locations
        EmailSettings

        'tools
        UploadICD
        PolicyRenewal
        IMISExtracts
        Report
        Reports
        FeedbackPrompt
        Utilities
        Funding
    End Enum
End Class
