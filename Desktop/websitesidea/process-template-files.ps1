# Template list with their source folders
$templates = @{
    "inance" = "Template Sites\Inance Free Website Template - Free-CSS.com.zip"
    "mediplus" = "Template Sites\Mediplus Lite Free Website Template - Free-CSS.com.zip"
    "listrace" = "Template Sites\Listrace Free Website Template - Free-CSS.com.zip"
    "makaan" = "Template Sites\Makaan Free Website Template - Free-CSS.com.zip"
    "rent4u" = "Template Sites\Rent4u Free Website Template - Free-CSS.com.zip"
    "woody" = "Template Sites\WooDY Free Website Template - Free-CSS.com.zip"
    "jobentry" = "Template Sites\JobEntry Free Website Template - Free-CSS.com.zip"
    "seocompany" = "Template Sites\The SEO Company Free Website Template - Free-CSS.com.zip"
    "giftos" = "Template Sites\Giftos Free Website Template - Free-CSS.com.zip"
    "fitapp" = "Template Sites\FitApp Free Website Template - Free-CSS.com.zip"
    "chocolux" = "Template Sites\Chocolux Free Website Template - Free-CSS.com.zip"
    "honey" = "Template Sites\Honey Free Website Template - Free-CSS.com.zip"
    "grandcoffee" = "Template Sites\Grandcoffee Free Website Template - Free-CSS.com.zip"
}

foreach ($template in $templates.Keys) {
    $sourcePath = $templates[$template]
    $targetPath = "templates\$template\template-files"
    
    Write-Host "Processing $template..."
    
    # Extract template files
    if (Test-Path $sourcePath) {
        # Create target directory if it doesn't exist
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }
        
        # Extract to temp directory
        Write-Host "Extracting $sourcePath..."
        Expand-Archive -Path $sourcePath -DestinationPath "$targetPath\temp" -Force
        
        # Find the first HTML file to use as preview
        $htmlFile = Get-ChildItem -Path "$targetPath\temp" -Filter "*.html" -Recurse | Select-Object -First 1
        
        if ($htmlFile) {
            # Save the folder path containing the HTML file
            $templateFolder = $htmlFile.Directory.FullName
            
            # Look for JPG or PNG files for preview
            $previewFile = Get-ChildItem -Path $templateFolder -Include *.jpg,*.png -File -Recurse | Select-Object -First 1
            if ($previewFile) {
                Copy-Item -Path $previewFile.FullName -Destination "$targetPath\preview.jpg" -Force
                Write-Host "Created preview image for $template"
            }
            
            # Create template zip
            Write-Host "Creating ZIP archive for $template..."
            Compress-Archive -Path "$templateFolder\*" -DestinationPath "$targetPath\template.zip" -Force
        }
        else {
            Write-Host "No HTML files found in $template"
        }
        
        # Clean up temp files
        Remove-Item -Path "$targetPath\temp" -Recurse -Force
    }
    else {
        Write-Host "Source file not found: $sourcePath"
    }
}

Write-Host "Template files processing complete!"
