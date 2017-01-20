namespace SpellGenerator
{
    partial class Application
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
            this.writeButton = new System.Windows.Forms.Button();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.entryLabel = new System.Windows.Forms.Label();
            this.entryField = new System.Windows.Forms.TextBox();
            this.addButton = new System.Windows.Forms.Button();
            this.Display = new System.Windows.Forms.Label();
            this.gameobjectField = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.nameField = new System.Windows.Forms.TextBox();
            this.domainUpDown1 = new System.Windows.Forms.DomainUpDown();
            this.SuspendLayout();
            // 
            // writeButton
            // 
            this.writeButton.Location = new System.Drawing.Point(12, 188);
            this.writeButton.Name = "writeButton";
            this.writeButton.Size = new System.Drawing.Size(372, 23);
            this.writeButton.TabIndex = 1;
            this.writeButton.Text = "Write";
            this.writeButton.UseVisualStyleBackColor = true;
            this.writeButton.Click += new System.EventHandler(this.writeButton_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Location = new System.Drawing.Point(0, 223);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(396, 22);
            this.statusStrip1.TabIndex = 4;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // entryLabel
            // 
            this.entryLabel.AutoSize = true;
            this.entryLabel.Location = new System.Drawing.Point(9, 19);
            this.entryLabel.Name = "entryLabel";
            this.entryLabel.Size = new System.Drawing.Size(31, 13);
            this.entryLabel.TabIndex = 24;
            this.entryLabel.Text = "Entry";
            // 
            // entryField
            // 
            this.entryField.Location = new System.Drawing.Point(72, 16);
            this.entryField.Name = "entryField";
            this.entryField.Size = new System.Drawing.Size(312, 20);
            this.entryField.TabIndex = 23;
            // 
            // addButton
            // 
            this.addButton.Location = new System.Drawing.Point(12, 146);
            this.addButton.Name = "addButton";
            this.addButton.Size = new System.Drawing.Size(372, 23);
            this.addButton.TabIndex = 25;
            this.addButton.Text = "Add";
            this.addButton.UseVisualStyleBackColor = true;
            this.addButton.Click += new System.EventHandler(this.addButton_Click);
            // 
            // Display
            // 
            this.Display.AutoSize = true;
            this.Display.BackColor = System.Drawing.SystemColors.Control;
            this.Display.Location = new System.Drawing.Point(0, 65);
            this.Display.Name = "Display";
            this.Display.Size = new System.Drawing.Size(66, 13);
            this.Display.TabIndex = 27;
            this.Display.Text = "GameObject";
            // 
            // gameobjectField
            // 
            this.gameobjectField.Location = new System.Drawing.Point(72, 62);
            this.gameobjectField.Name = "gameobjectField";
            this.gameobjectField.Size = new System.Drawing.Size(312, 20);
            this.gameobjectField.TabIndex = 26;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.SystemColors.Control;
            this.label1.Location = new System.Drawing.Point(2, 105);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(35, 13);
            this.label1.TabIndex = 29;
            this.label1.Text = "Name";
            // 
            // nameField
            // 
            this.nameField.Location = new System.Drawing.Point(74, 102);
            this.nameField.Name = "nameField";
            this.nameField.Size = new System.Drawing.Size(310, 20);
            this.nameField.TabIndex = 28;
            // 
            // domainUpDown1
            // 
            this.domainUpDown1.Location = new System.Drawing.Point(270, 223);
            this.domainUpDown1.Name = "domainUpDown1";
            this.domainUpDown1.Size = new System.Drawing.Size(8, 20);
            this.domainUpDown1.TabIndex = 30;
            this.domainUpDown1.Text = "domainUpDown1";
            // 
            // Application
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(396, 245);
            this.Controls.Add(this.domainUpDown1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.nameField);
            this.Controls.Add(this.Display);
            this.Controls.Add(this.gameobjectField);
            this.Controls.Add(this.addButton);
            this.Controls.Add(this.entryLabel);
            this.Controls.Add(this.entryField);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.writeButton);
            this.Name = "Application";
            this.Text = "Building Item Generator - Written by Fractional";
            this.Load += new System.EventHandler(this.Application_Load_1);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Button writeButton;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.Label entryLabel;
        private System.Windows.Forms.TextBox entryField;
        private System.Windows.Forms.Button addButton;
        private System.Windows.Forms.Label Display;
        private System.Windows.Forms.TextBox gameobjectField;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox nameField;
        private System.Windows.Forms.DomainUpDown domainUpDown1;
    }
}

