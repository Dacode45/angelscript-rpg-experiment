class UWarriorAttributeSet : UAngelscriptAttributeSet
{
	UPROPERTY(BlueprintReadOnly, Category = "Health")
	FAngelscriptGameplayAttributeData CurrentHealth;

	UPROPERTY(BlueprintReadOnly, Category = "Health")
	FAngelscriptGameplayAttributeData MaxHealth;

	UPROPERTY(BlueprintReadOnly, Category = "Rage")
	FAngelscriptGameplayAttributeData CurrentRage;

	UPROPERTY(BlueprintReadOnly, Category = "Rage")
	FAngelscriptGameplayAttributeData MaxRage;

	UPROPERTY(BlueprintReadOnly, Category = "Damage")
	FAngelscriptGameplayAttributeData AttackPower;

	UPROPERTY(BlueprintReadOnly, Category = "Damage")
	FAngelscriptGameplayAttributeData DefensePower;

	UPROPERTY(BlueprintReadOnly, Category = "Damage")
	FAngelscriptGameplayAttributeData DamageTaken;

	default CurrentHealth.Initialize(1.f);
	default MaxHealth.Initialize(1.f);
	default CurrentRage.Initialize(1.f);
	default MaxRage.Initialize(1.f);
	default AttackPower.Initialize(1.f);
	default DefensePower.Initialize(1.f);
}