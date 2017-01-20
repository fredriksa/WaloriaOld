namespace RandomItemStats
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.itemEntryField = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.loadItemButton = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.beforeTextBox = new System.Windows.Forms.RichTextBox();
            this.afterTextBox = new System.Windows.Forms.RichTextBox();
            this.variationButton = new System.Windows.Forms.Button();
            this.saveButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // itemEntryField
            // 
            this.itemEntryField.Location = new System.Drawing.Point(53, 12);
            this.itemEntryField.Name = "itemEntryField";
            this.itemEntryField.Size = new System.Drawing.Size(100, 20);
            this.itemEntryField.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(27, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Item";
            // 
            // loadItemButton
            // 
            this.loadItemButton.Location = new System.Drawing.Point(179, 10);
            this.loadItemButton.Name = "loadItemButton";
            this.loadItemButton.Size = new System.Drawing.Size(85, 23);
            this.loadItemButton.TabIndex = 2;
            this.loadItemButton.Text = "Load";
            this.loadItemButton.UseVisualStyleBackColor = true;
            this.loadItemButton.Click += new System.EventHandler(this.loadItemButton_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(50, 63);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(38, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Before";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(209, 63);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(29, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "After";
            // 
            // beforeTextBox
            // 
            this.beforeTextBox.Location = new System.Drawing.Point(15, 92);
            this.beforeTextBox.Name = "beforeTextBox";
            this.beforeTextBox.Size = new System.Drawing.Size(129, 179);
            this.beforeTextBox.TabIndex = 5;
            this.beforeTextBox.Text = "";
            // 
            // afterTextBox
            // 
            this.afterTextBox.Location = new System.Drawing.Point(162, 92);
            this.afterTextBox.Name = "afterTextBox";
            this.afterTextBox.Size = new System.Drawing.Size(129, 179);
            this.afterTextBox.TabIndex = 6;
            this.afterTextBox.Text = "";
            // 
            // variationButton
            // 
            this.variationButton.Location = new System.Drawing.Point(12, 294);
            this.variationButton.Name = "variationButton";
            this.variationButton.Size = new System.Drawing.Size(276, 23);
            this.variationButton.TabIndex = 7;
            this.variationButton.Text = "Generate Variations";
            this.variationButton.UseVisualStyleBackColor = true;
            this.variationButton.Click += new System.EventHandler(this.variationButton_Click);
            // 
            // saveButton
            // 
            this.saveButton.Location = new System.Drawing.Point(12, 323);
            this.saveButton.Name = "saveButton";
            this.saveButton.Size = new System.Drawing.Size(273, 23);
            this.saveButton.TabIndex = 8;
            this.saveButton.Text = "Save Changes";
            this.saveButton.UseVisualStyleBackColor = true;
            this.saveButton.Click += new System.EventHandler(this.saveButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(303, 352);
            this.Controls.Add(this.saveButton);
            this.Controls.Add(this.variationButton);
            this.Controls.Add(this.afterTextBox);
            this.Controls.Add(this.beforeTextBox);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.loadItemButton);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.itemEntryField);
            this.Name = "Form1";
            this.Text = "RandomItemStats";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox itemEntryField;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button loadItemButton;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.RichTextBox beforeTextBox;
        public System.Windows.Forms.RichTextBox afterTextBox;
        private System.Windows.Forms.Button variationButton;
        private System.Windows.Forms.Button saveButton;
    }
}

