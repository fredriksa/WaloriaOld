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
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.writeButton = new System.Windows.Forms.Button();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.readButton = new System.Windows.Forms.Button();
            this.skillLineList = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.skillLineAbilityList = new System.Windows.Forms.ListBox();
            this.loadSpellsButton = new System.Windows.Forms.Button();
            this.updateSkillLineAbilitiesButton = new System.Windows.Forms.Button();
            this.powerTypeCombo = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.Location = new System.Drawing.Point(12, 47);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(171, 420);
            this.listBox1.TabIndex = 0;
            // 
            // writeButton
            // 
            this.writeButton.Location = new System.Drawing.Point(772, 482);
            this.writeButton.Name = "writeButton";
            this.writeButton.Size = new System.Drawing.Size(194, 23);
            this.writeButton.TabIndex = 1;
            this.writeButton.Text = "Save Changes";
            this.writeButton.UseVisualStyleBackColor = true;
            this.writeButton.Click += new System.EventHandler(this.writeButton_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Location = new System.Drawing.Point(0, 517);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(978, 22);
            this.statusStrip1.TabIndex = 4;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // readButton
            // 
            this.readButton.Location = new System.Drawing.Point(12, 482);
            this.readButton.Name = "readButton";
            this.readButton.Size = new System.Drawing.Size(171, 23);
            this.readButton.TabIndex = 41;
            this.readButton.Text = "Read";
            this.readButton.UseVisualStyleBackColor = true;
            this.readButton.Click += new System.EventHandler(this.readButton_Click);
            // 
            // skillLineList
            // 
            this.skillLineList.FormattingEnabled = true;
            this.skillLineList.Location = new System.Drawing.Point(218, 47);
            this.skillLineList.Name = "skillLineList";
            this.skillLineList.Size = new System.Drawing.Size(171, 420);
            this.skillLineList.TabIndex = 42;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(56, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(56, 13);
            this.label1.TabIndex = 43;
            this.label1.Text = "Spells.dbc";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(266, 22);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(67, 13);
            this.label2.TabIndex = 44;
            this.label2.Text = "SkillLine.dbc";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(453, 22);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(94, 13);
            this.label3.TabIndex = 45;
            this.label3.Text = "SkillLineAbility.dbc";
            // 
            // skillLineAbilityList
            // 
            this.skillLineAbilityList.FormattingEnabled = true;
            this.skillLineAbilityList.Location = new System.Drawing.Point(427, 47);
            this.skillLineAbilityList.Name = "skillLineAbilityList";
            this.skillLineAbilityList.Size = new System.Drawing.Size(171, 420);
            this.skillLineAbilityList.TabIndex = 46;
            // 
            // loadSpellsButton
            // 
            this.loadSpellsButton.Location = new System.Drawing.Point(218, 482);
            this.loadSpellsButton.Name = "loadSpellsButton";
            this.loadSpellsButton.Size = new System.Drawing.Size(171, 23);
            this.loadSpellsButton.TabIndex = 47;
            this.loadSpellsButton.Text = "Read";
            this.loadSpellsButton.UseVisualStyleBackColor = true;
            this.loadSpellsButton.Click += new System.EventHandler(this.loadSpellsButton_Click);
            // 
            // updateSkillLineAbilitiesButton
            // 
            this.updateSkillLineAbilitiesButton.Location = new System.Drawing.Point(772, 444);
            this.updateSkillLineAbilitiesButton.Name = "updateSkillLineAbilitiesButton";
            this.updateSkillLineAbilitiesButton.Size = new System.Drawing.Size(194, 23);
            this.updateSkillLineAbilitiesButton.TabIndex = 48;
            this.updateSkillLineAbilitiesButton.Text = "Update Abilities";
            this.updateSkillLineAbilitiesButton.UseVisualStyleBackColor = true;
            this.updateSkillLineAbilitiesButton.Click += new System.EventHandler(this.updateSkillLineAbilitiesButton_Click);
            // 
            // powerTypeCombo
            // 
            this.powerTypeCombo.FormattingEnabled = true;
            this.powerTypeCombo.Location = new System.Drawing.Point(845, 401);
            this.powerTypeCombo.Name = "powerTypeCombo";
            this.powerTypeCombo.Size = new System.Drawing.Size(121, 21);
            this.powerTypeCombo.TabIndex = 49;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(769, 404);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(61, 13);
            this.label4.TabIndex = 50;
            this.label4.Text = "PowerType";
            // 
            // Application
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(978, 539);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.powerTypeCombo);
            this.Controls.Add(this.updateSkillLineAbilitiesButton);
            this.Controls.Add(this.loadSpellsButton);
            this.Controls.Add(this.skillLineAbilityList);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.skillLineList);
            this.Controls.Add(this.readButton);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.writeButton);
            this.Controls.Add(this.listBox1);
            this.Name = "Application";
            this.Text = "SpellModifier";
            this.Load += new System.EventHandler(this.Application_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.Button writeButton;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.Button readButton;
        private System.Windows.Forms.ListBox skillLineList;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ListBox skillLineAbilityList;
        private System.Windows.Forms.Button loadSpellsButton;
        private System.Windows.Forms.Button updateSkillLineAbilitiesButton;
        private System.Windows.Forms.ComboBox powerTypeCombo;
        private System.Windows.Forms.Label label4;
    }
}

