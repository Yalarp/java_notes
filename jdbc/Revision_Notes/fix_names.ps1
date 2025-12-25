# Rename files to match implementation plan numbering
# Part 3: 20-29

$part3 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_03_Session_Management"
# Current: 20,21,22,23,24,25_Forward,26_Init,26_Request,27_Session,28_Include,29_Init
# Target: 20,21,22,23,24,25_Session,26_Request,27_Forward,28_Include,29_Init

# Move to temp first to avoid conflicts
if (Test-Path "$part3\25_Forward_vs_Redirect.md") { Rename-Item "$part3\25_Forward_vs_Redirect.md" "$part3\temp_forward.md" }
if (Test-Path "$part3\27_Session_Timeout.md") { Rename-Item "$part3\27_Session_Timeout.md" "$part3\25_Session_Timeout.md" }
if (Test-Path "$part3\temp_forward.md") { Rename-Item "$part3\temp_forward.md" "$part3\27_Forward_vs_Redirect.md" }
if (Test-Path "$part3\26_Init_Parameters.md") { Remove-Item "$part3\26_Init_Parameters.md" -Force }

Write-Host "Part 3 done"

# Part 4: 30-39
$part4 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_04_Filters_JSP"
# Remove old numbered files and keep correct ones
$oldFiles = @("28_Filter_Basics.md","29_JSP_Introduction.md","30_JSP_Elements.md","31_JSP_Directives.md","32_Thread_Safety.md","33_Load_on_Startup.md","34_Welcome_Error_Pages.md")
foreach ($f in $oldFiles) {
    $path = "$part4\$f"
    if (Test-Path $path) { Remove-Item $path -Force }
}
Write-Host "Part 4 done"

# Part 5: 40-47
$part5 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_05_EL_JSTL"
$oldFiles5 = @("35_JSP_Scopes.md","36_Expression_Language.md","37_JSTL_Core.md","38_Standard_Actions.md")
foreach ($f in $oldFiles5) {
    $path = "$part5\$f"
    if (Test-Path $path) { Remove-Item $path -Force }
}
Write-Host "Part 5 done"

# Part 6: 48-51
$part6 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_06_MVC_CustomTags"
$oldFiles6 = @("39_MVC_Architecture.md","40_Custom_Tags.md")
foreach ($f in $oldFiles6) {
    $path = "$part6\$f"
    if (Test-Path $path) { Remove-Item $path -Force }
}
Write-Host "Part 6 done"

# Part 7: 52-59
$part7 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_07_Hibernate_Basics"
$oldFiles7 = @("41_ORM_Introduction.md","42_Hibernate_Setup.md","43_Entity_Mapping.md","44_Session_Transaction.md","45_CRUD_Operations.md","46_HQL.md")
foreach ($f in $oldFiles7) {
    $path = "$part7\$f"
    if (Test-Path $path) { Remove-Item $path -Force }
}
Write-Host "Part 7 done"

# Part 8: 60-70
$part8 = "c:\Users\2706p\Desktop\mcq\java\Revision_Notes\Part_08_Hibernate_Advanced"
$oldFiles8 = @("47_Entity_Relationships.md","48_Caching.md")
foreach ($f in $oldFiles8) {
    $path = "$part8\$f"
    if (Test-Path $path) { Remove-Item $path -Force }
}
Write-Host "Part 8 done"

Write-Host "All files cleaned up!"
